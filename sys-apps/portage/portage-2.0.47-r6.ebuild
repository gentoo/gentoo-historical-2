# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-2.0.47-r6.ebuild,v 1.2 2003/02/27 10:49:10 carpaski Exp $

IUSE="build"

# If the old /lib/sandbox.so is in /etc/ld.so.preload, it can
# cause everything to segfault !!
export SANDBOX_DISABLED="1"

S=${WORKDIR}/${PF}
SLOT="0"
DESCRIPTION="Portage ports system"
SRC_URI="http://gentoo.twobit.net/portage/${PF}.tar.bz2 mirror://gentoo/${PF}.tar.bz2"
HOMEPAGE="http://www.gentoo.org"
KEYWORDS="alpha arm hppa mips ppc sparc x86"
LICENSE="GPL-2"
RDEPEND="!build? ( >=sys-apps/fileutils-4.1.8 dev-python/python-fchksum >=dev-lang/python-2.2.1 sys-apps/debianutils >=sys-apps/bash-2.05a )"

get_portver() {
	python -c "import portage,string; print string.join(portage.pkgsplit(portage.best(portage.db[\"${ROOT}\"][\"vartree\"].dbapi.match(\"sys-apps/portage\"))))"
}

compare_pver() {
	if python -c "import portage,string,sys; sys.exit(portage.pkgcmp(string.split(\"$1\"),string.split(\"$2\"))>=0)"; then
		return 0
	fi
	return 1
}

src_unpack() {
	cd ${WORKDIR}
	echo tar xjf ${DISTDIR}/${PF}.tar.bz2
	tar xjf ${DISTDIR}/${PF}.tar.bz2 || die "No portage tarball in distfiles."
	#get_portver > ${WORKDIR}/previous-version
}

src_compile() {
	cd ${S}/src; gcc ${CFLAGS} tbz2tool.c -o tbz2tool
	cd ${S}/src/sandbox-1.1
	if [ "${ARCH}" = "x86" ]; then
		make CFLAGS="-march=i386 -O1 -pipe" || die
	else
		make || die
	fi
}

src_install() {
	#config files
	cd ${S}/cnf
	insinto /etc
	case "$ARCH" in
		alpha )
		newins make.globals.alpha make.globals
		newins make.conf.alpha make.conf
		;;
		arm )
		newins make.globals.arm make.globals
		newins make.conf.arm make.conf
		;;
		hppa )
		newins make.globals.hppa make.globals
		newins make.conf.hppa make.conf
		;;
		mips )
		newins make.globals.mips make.globals
		newins make.conf.mips make.conf
		;;
		ppc )
		newins make.globals.ppc make.globals
		newins make.conf.ppc make.conf
		;;
		sparc )
		newins make.globals.sparc make.globals
		newins make.conf.sparc make.conf
		;;
		* )
		doins make.globals make.conf
		;;
	esac
	doins etc-update.conf dispatch-conf.conf
	#python modules
	cd ${S}/src/python-missingos
	chmod +x setup.py
	./setup.py install --root ${D} || die
	cd ${S}/pym
	insinto /usr/lib/python2.2/site-packages
	doins xpak.py portage.py output.py


	#binaries, libraries and scripts
	dodir /usr/lib/portage/bin
	cd ${S}/bin
	exeinto /usr/lib/portage/bin
	doexe *
	dosym emake /usr/lib/portage/bin/pmake
	doexe ${S}/src/tbz2tool
	
	#install sandbox
	cd ${S}/src/sandbox-1.1
	make DESTDIR=${D} install || die

	#symlinks
	dodir /usr/bin /usr/sbin
	dosym ../lib/portage/bin/emerge /usr/bin/emerge
	dosym ../lib/portage/bin/pkgmerge /usr/sbin/pkgmerge
	dosym ../lib/portage/bin/ebuild /usr/sbin/ebuild
	dosym ../lib/portage/bin/ebuild.sh /usr/sbin/ebuild.sh
	dosym ../lib/portage/bin/etc-update /usr/sbin/etc-update
	
	#dosym /usr/lib/portage/bin/portage-maintain /usr/sbin/portage-maintain
	dosym ../lib/portage/bin/env-update /usr/sbin/env-update
	dosym ../lib/portage/bin/xpak /usr/bin/xpak
	dosym ../lib/portage/bin/repoman /usr/bin/repoman
	dosym ../lib/portage/bin/tbz2tool /usr/bin/tbz2tool

	dosym ../lib/portage/bin/g-cpan.pl /usr/bin/g-cpan.pl
	dosym ../lib/portage/bin/quickpkg /usr/bin/quickpkg
	dosym ../lib/portage/bin/regenworld /usr/sbin/regenworld
	dosym ../lib/portage/bin/emerge-webrsync /usr/sbin/emerge-webrsync
	dosym ../lib/portage/bin/dispatch-conf /usr/sbin/dispatch-conf

	dosym newins /usr/lib/portage/bin/donewins
	
	# man pages
	doman ${S}/man/*.[15]
	
	# temp dir creation
	dodir /var/tmp
	chmod 1777 ${D}/var/tmp
	touch ${D}/var/tmp/.keep
	
	#documentation
	dodoc ${S}/ChangeLog
}

pkg_postinst() {
	local x

	#disable global sandbox if it's active (it's been deprecated)
	if [ -f /etc/ld.so.preload ] ; then
		cp /etc/ld.so.preload ${T}
		grep -v libsandbox ${T}/ld.so.preload > /etc/ld.so.preload
	fi
	
	#remove possible previous sandbox files that could cause conflicts
	if [ -d /usr/lib/sandbox ]; then
		rm -f ${ROOT}/usr/lib/portage/bin/ebuild.sh.orig
		rm -f ${ROOT}/usr/lib/portage/pym/portage.py.orig
		rm -f ${ROOT}/usr/bin/sandbox
		rm -rf ${ROOT}/usr/lib/sandbox
	fi
	
	#yank old cache files
	if [ -d /var/cache/edb ]
	then
		rm -f /var/cache/edb/xcache.p
		rm -f /var/cache/edb/mtimes
	fi

	echo
	einfo "NOTICE: PLEASE update your make.globals. All user changes to variables"
	einfo "in make.globals should be placed in make.conf. DO NOT MODIFY make.globals."
	echo
	einfo "NOTICE: The wheel group requirement for non-root users has been changed to"
	einfo "group portage. Group portage must be a valid group for user to use portage."
	echo
	einfo "Feature additions are noted in help and make.conf descriptions. Update"
	einfo "them using 'etc-update' please. Maintaining current configs for portage"
	einfo "and other system packages is fairly important for the continued health"
	einfo "of your system."
	echo
	einfo "A worldfile rebuilding script is available to regenerate entries that"
	einfo "should be in your worldfile but were removed by a recently discovered"
	einfo "'-e bug' or if you deleted it: run 'regenworld' as root."
	echo
	einfo "The 2.0.47 line of portages contains an optional userpriv mode that"
	einfo "enables portage to drop root privleges and run as a normal user. It is"
	einfo "enabled via FEATURES by adding userpriv."
	echo
	einfo "Please 'emerge sync' after merging portage to update some permissions."
	echo
	if [ -z $PORTAGE_TEST ]; then
		echo -ne "\a" ; sleep 1 ; echo -ne "\a" ; sleep 1 ; echo -ne "\a" ; sleep 1
		echo -ne "\a" ; sleep 1 ; echo -ne "\a" ; sleep 1 ; echo -ne "\a" ; sleep 1
		sleep 5

		# Kill the existing counter and generate a new one.
		echo -n "Recalculating the counter... "
		mv /var/cache/edb/counter /var/cache/edb/counter.old
		python -c 'import portage; portage.counter_tick_core("/")' &>/dev/null
		if [ -f /var/cache/edb/counter ] ; then
			echo "Counter updated successfully."
			rm -f /var/cache/edb/counter.old
		else
			echo "FAILED to update counter."
			echo "!!! This is a problem."
			mv /var/cache/edb/counter.old /var/cache/edb/counter
		fi

		# Changes in the size of auxdbkeys can cause aux_get() problems.
		echo -n ">>> Clearing invalid entries in dependancy cache..."
		cd ${ROOT}var/cache/edb/dep
		# 2>&1 >/dev/null <---- Kills stdout, replaces it with stderr
		AUXDBKEYLEN="$(python -c 'import portage,sys; sys.stderr.write(str(len(portage.auxdbkeys)))' 2>&1 >/dev/null)"
		find ${ROOT}var/cache/edb/dep -type f -exec wc -l {} \; | egrep -v "^ *${AUXDBKEYLEN}" | sed 's:^ \+[0-9]\+ \+\([^ ]\+\)$:\1:' 2>/dev/null | xargs -n 50 -r rm -f
		echo " ...done!"
	fi # PORTAGE_TESTING

	#fix cache (could contain staleness)
	if [ ! -d ${ROOT}var/cache/edb/dep ]
	then
		#upgrade /var/db/pkg library; conditional required for build image creation
		if [ -d ${ROOT}var/db/pkg ]
		then
			echo ">>> Database upgrade..."
			cd ${ROOT}var/db/pkg
			for x in *
			do
				[ ! -d "$x" ] && continue
				#go into each category directory so we don't overload the python2.2 command-line
				cd $x
				#fix silly output from this command (hack)
				python2.2 ${ROOT}usr/lib/portage/bin/db-update.py `find -name VIRTUAL` > /dev/null
			cd ..
			done
			echo ">>> Database upgrade complete."
			#remove old virtual directory to prevent virtual deps from getting messed-up
			[ -d ${ROOT}var/db/pkg/virtual ] && rm -rf ${ROOT}var/db/pkg/virtual
		fi
		install -d -m0755 ${ROOT}var/cache/edb
		install -d -m2775 -o root -g wheel ${ROOT}var/cache/edb/dep
	fi

	rm -f ${ROOT}usr/lib/python2.2/site-packages/portage.py[co]
	rm -f ${ROOT}usr/lib/python2.2/site-packages/output.py[co]
	chmod 2775 ${ROOT}var/cache/edb/dep ${ROOT}var/cache/edb/dep/*
	chown -R root.wheel ${ROOT}var/cache/edb/dep
	
	# we gotta re-compile these modules and deal with systems with clock skew (stale compiled files)
	python -c "import py_compile; py_compile.compile('${ROOT}usr/lib/python2.2/site-packages/portage.py')" || die
	python -O -c "import py_compile; py_compile.compile('${ROOT}usr/lib/python2.2/site-packages/portage.py')" || die
	python -c "import py_compile; py_compile.compile('${ROOT}usr/lib/python2.2/site-packages/output.py')" || die
	python -O -c "import py_compile; py_compile.compile('${ROOT}usr/lib/python2.2/site-packages/output.py')" || die
	python -c "import py_compile; py_compile.compile('${ROOT}usr/lib/portage/bin/emergehelp.py')" || die
	python -O -c "import py_compile; py_compile.compile('${ROOT}usr/lib/portage/bin/emergehelp.py')" || die

	cd /sbin/
	if [ -f "${FILESDIR}/functions.sh.diff" ]; then
		patch -sf < ${FILESDIR}/functions.sh.diff &>/dev/null
		rm -f functions.sh~ functions.sh.rej
	fi
	cd ${S}

	mkdir            ${DISTDIR}/cvs-src &>/dev/null
	chgrp -R portage ${DISTDIR}/cvs-src &>/dev/null
	chmod -R g+rw    ${DISTDIR}/cvs-src &>/dev/null

	cp /sbin/functions.sh /sbin/functions.sh.orig
	sed '/logger/s: \$\*: "$*":' < /sbin/functions.sh.orig > /sbin/functions.sh 2>/dev/null
	rm -f /sbin/functions.sh.orig

}
