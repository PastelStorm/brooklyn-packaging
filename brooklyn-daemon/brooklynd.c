#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <syslog.h>

extern char **environ;

static void skeleton_daemon()
{
    pid_t pid;

    /* Fork off the parent process */
    pid = fork();

    /* An error occurred */
    if (pid < 0)
        exit(EXIT_FAILURE);

    /* Success: Let the parent terminate */
    if (pid > 0)
        exit(EXIT_SUCCESS);

    /* On success: The child process becomes session leader */
    if (setsid() < 0)
        exit(EXIT_FAILURE);

    /* Catch, ignore and handle signals */
    //TODO: Implement a working signal handler */
    signal(SIGCHLD, SIG_IGN);
    signal(SIGHUP, SIG_IGN);

    /* Fork off for the second time*/
    pid = fork();

    /* An error occurred */
    if (pid < 0)
        exit(EXIT_FAILURE);

    /* Success: Let the parent terminate */
    if (pid > 0)
        exit(EXIT_SUCCESS);

    /* Set new file permissions */
    umask(0);

    /* Change the working directory to the root directory */
    chdir("/");

    /* Close all open file descriptors */
    int i;
    for (i = sysconf(_SC_OPEN_MAX); i>0; --i)
    {
        close (i);
    }

    /* Log the success to syslog */
    syslog(LOG_NOTICE, "Brooklyn started");
}

void run_brooklyn()
{
    char *classpath = getenv("BROOKLYN_CLASSPATH");
    char *java_opts = getenv("BROOKLYN_JAVA_OPTS");
    char *brooklyn_class = "org.apache.brooklyn.cli.Main";
    char *cmd = "launch";
    execl("/usr/bin/java", "java", "-cp", classpath, java_opts, brooklyn_class, cmd, NULL);
}


int main(int argc, char *argv[])
{
    skeleton_daemon();

    while (1)
    {
        run_brooklyn();
        sleep (20);
    }

    return EXIT_SUCCESS;
}
