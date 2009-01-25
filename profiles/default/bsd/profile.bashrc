if [[ ${EBUILD_PHASE} == compile ]] ; then
	if grep -q "Assume that mode_t is passed compatibly" ${S} -r --include openat.c; then
		eerror "The source code contains a faulty openat.c unit from gnulib."
		eerror "Please report this on Gentoo Bugzilla in Gentoo BSD product."
		eerror "http://bugs.gentoo.org/enter_bug.cgi?product=Gentoo%20BSD"
		die "Broken openat.c gnulib unit."
	fi
        if grep -q "test .*==" "${S}" -r --include configure; then
                eerror "Found a non POSIX test construction in a configure script"
                eerror "The configure checks of this package may not function properly"
                eerror "Please report this on Gentoo Bugzilla in Gentoo BSD product."
                eerror "http://bugs.gentoo.org/enter_bug.cgi?product=Gentoo%20BSD"
        fi
fi
