
#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <syslog.h>

static void skeleton_daemon()
{
    pid_t pid;

    // Fork off the parent process
    pid = fork();
    if (pid < 0) {
        syslog(LOG_NOTICE, "Can't fork off the parent process, exiting...");
        exit(EXIT_FAILURE);
    }   
    // If we got a good PID, then we can exit the parent process
    if (pid > 0) {
        exit(EXIT_SUCCESS);
    }   

    // On success: The child process becomes session leader
    if (setsid() < 0) {
        syslog(LOG_NOTICE, "Can't set Unique Session ID for the child process, exiting...");
        exit(EXIT_FAILURE);
    }   

    // Catch, ignore and handle signals
    signal(SIGCHLD, SIG_IGN);
    signal(SIGHUP, SIG_IGN);

    // Fork off for the second time
    pid = fork();
    if (pid < 0) {
        syslog(LOG_NOTICE, "Can't fork off the parent process, exiting...");
        exit(EXIT_FAILURE);
    }   
    // If we got a good PID, then we can exit the parent process
    if (pid > 0) {
        exit(EXIT_SUCCESS);
    }   

    // Set new file permissions
    umask(0);

    // Change the working directory
    if (chdir("/") < 0) {
        syslog(LOG_NOTICE, "Can't change the working directory, exiting...");
        exit(EXIT_FAILURE);
    }

    // Close all open file descriptors
    int i;
    for (i = sysconf(_SC_OPEN_MAX); i>0; --i) {
        close (i);
    }
}

void run_brooklyn()
{
    char *brooklyn_class = "org.apache.brooklyn.cli.Main";
    char *cmd = "launch";

    char *pidfile_name = "/var/run/brooklyn.pid";
    FILE *pidfile = fopen(pidfile_name, "w");
    if (! pidfile) {
        syslog(LOG_NOTICE, "Can't open %s for writing, exiting...", pidfile_name);
        exit(EXIT_FAILURE);
    }
    fprintf(pidfile, "%d", getpid());
    fclose(pidfile);
    syslog(LOG_NOTICE, "Brooklyn started, pid: %d", getpid());

    char *java_exec = "/usr/bin/java";
    if (access(java_exec, R_OK) != -1) {
        execl("/usr/bin/java", "java", brooklyn_class, cmd, NULL);
    } else {
        syslog(LOG_NOTICE, "Can't find Java executable in %s, exiting...", java_exec);
        exit(EXIT_FAILURE);
    }
}


int main(int argc, char *argv[])
{
    skeleton_daemon();

    while (1)
    {
        run_brooklyn();
        sleep (20);
    }

    exit(EXIT_SUCCESS);
}
