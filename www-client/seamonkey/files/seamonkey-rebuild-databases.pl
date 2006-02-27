#!/usr/bin/perl

use File::Path;
use File::Copy;
use File::Glob ":glob";
use POSIX ":sys_wait_h";

$timeout = 60;

%{ENV}->{"MOZILLA_FIVE_HOME"}="/usr/lib/seamonkey";
%{ENV}->{"LD_LIBRARY_PATH"}="/usr/lib/seamonkey";

umask 022;

if ( -f "/usr/lib/seamonkey/regxpcom" )
{
    # remove all of the old files
    rmtree("/usr/lib/seamonkey/chrome/overlayinfo");
    unlink </usr/lib/seamonkey/chrome/*.rdf>;
    unlink("/usr/lib/seamonkey/component.reg");
    unlink("/usr/lib/seamonkey/components/compreg.dat");
    unlink("/usr/lib/seamonkey/components/xpti.dat");

    # create a new clean path
    mkpath("/usr/lib/seamonkey/chrome/overlayinfo");

    # rebuild the installed-chrome.txt file from the installed
    # languages
    if ( -f "/usr/lib/seamonkey/chrome/lang/installed-chrome.txt" ) {
	rebuild_lang_files();
    }

    # run regxpcom
    $pid = fork();

    # I am the child.
    if ($pid == 0) {
	exec("/usr/lib/seamonkey/regxpcom > /dev/null 2> /dev/null");
    }
    # I am the parent.
    else {
	my $timepassed = 0;
	do {
	    $kid = waitpid($pid, &WNOHANG);
	    sleep(1);
	    $timepassed++;
        } until $kid == -1 || $timepassed > $timeout;

	# should we kill?
	if ($timepassed > $timeout) {
	    kill (9, $pid);
	    # kill -9 can leave threads hanging around
	    system("/usr/bin/killall -9 regxpcom");
	}
    }

    # and run regchrome for good measure
    $pid = fork();

    # I am the child.
    if ($pid == 0) {
	exec("/usr/lib/seamonkey/regchrome > /dev/null 2> /dev/null");
    }
    # I am the parent.
    else {
	my $timepassed = 0;
	do {
	    $kid = waitpid($pid, &WNOHANG);
	    sleep(1);
	    $timepassed++;
        } until $kid == -1 || $timepassed > $timeout;

	# should we kill?
	if ($timepassed > $timeout) {
	    kill (9, $pid);
	    # kill -9 can leave threads hanging around
	    system("/usr/bin/killall -9 regchrome");
	}
    }

}


sub rebuild_lang_files {
    unlink("/usr/lib/seamonkey/chrome/installed-chrome.txt");

    open (OUTPUT, "+>", "/usr/lib/seamonkey/chrome/installed-chrome.txt")||
	die("Failed to open installed-chrome.txt: $!\n");

    copy("/usr/lib/seamonkey/chrome/lang/installed-chrome.txt",
	 \*OUTPUT);

    foreach (bsd_glob("/usr/lib/seamonkey/chrome/lang/lang-*.txt")) {
	copy($_, \*OUTPUT);
    }

    copy("/usr/lib/seamonkey/chrome/lang/default.txt",
	 \*OUTPUT);
}
