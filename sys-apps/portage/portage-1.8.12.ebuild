# Copyright 1999-2002 Gentoo Technologies, Inc. Distributed under the terms
# of the GNU General Public License, v2 or later 
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-1.8.12.ebuild,v 1.1 2002/04/04 02:00:55 gbevin Exp $
 
S=${WORKDIR}/${P}
SLOT="0"
DESCRIPTION="Portage ports system"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org"
#debianutils is for "readlink"
#We need this if/then/else clause for compatibility with stuff that doesn't know !build?
if [ "`use build`" ]
then
	RDEPEND=""
else
	RDEPEND=">=sys-apps/fileutils-4.1.8 =dev-lang/python-2.2* sys-apps/debianutils"
fi

src_unpack() {
	#We are including the Portage bzipped tarball on CVS now, so that if a person's
	#emerge gets hosed, they are not completely stuck.
	cd ${WORKDIR}; tar xjf ${FILESDIR}/${PF}.tar.bz2
}

src_compile() {                           
	cd ${S}/src; gcc ${CFLAGS} tbz2tool.c -o tbz2tool
	cd ${S}/src/sandbox
	emake || die
}

pkg_preinst() {
	if [ -d /var/db/pkg/sys-apps/bash-2.05a ] && [ ! -d /var/db/pkg/sys-apps/bash-2.05a-r1 ]
	then
		eerror "You have to update your bash-2.05a installation."
		eerror "Please execute 'emerge sys-apps/bash' as root"
		eerror "before installing this version of portage."
		die
	fi
}

src_install() {
	#dep cache
	dodir /var/cache/edb/dep

	#config files
	cd ${S}/cnf
	insinto /etc
	doins make.globals make.conf

	#python modules
	cd ${S}/pym
	insinto /usr/lib/python2.2/site-packages
	doins xpak.py portage.py output.py

	# we gotta compile these modules
	python -c "import compileall; compileall.compile_dir('${D}/usr/lib/python2.2/site-packages')" || die
	python -O -c "import compileall; compileall.compile_dir('${D}/usr/lib/python2.2/site-packages')" || die
	
	#binaries, libraries and scripts
	dodir /usr/lib/portage/bin
	cd ${S}/bin
	exeinto /usr/lib/portage/bin
	doexe *
	dosym emake /usr/lib/portage/bin/pmake
	doexe ${S}/src/tbz2tool
	
	into /usr/lib/portage
	dobin ${S}/src/sandbox/sandbox
	dodir /usr/lib/portage/lib
	exeinto /usr/lib/portage/lib
	doexe ${S}/src/sandbox/libsandbox.so
	insinto //usr/lib/portage/lib
	doins ${S}/src/sandbox/sandbox.bashrc
	#reset into
	into /usr

	#symlinks
	dodir /usr/bin /usr/sbin
	dosym ../lib/portage/bin/emerge /usr/bin/emerge
	dosym ../lib/portage/bin/pkgmerge /usr/sbin/pkgmerge
	dosym ../lib/portage/bin/ebuild /usr/sbin/ebuild
	dosym ../lib/portage/bin/ebuild.sh /usr/sbin/ebuild.sh
	#dosym /usr/lib/portage/bin/portage-maintain /usr/sbin/portage-maintain
	dosym ../lib/portage/bin/env-update /usr/sbin/env-update
	dosym ../lib/portage/bin/xpak /usr/bin/xpak
	dosym ../lib/portage/bin/tbz2tool /usr/bin/tbz2tool
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
	if [ ! -e ${ROOT}/etc/make.profile ]
	then
		cd ${ROOT}/etc
		ln -sf ../usr/portage/profiles/default-1.0 make.profile
	fi
	local x
	#remove possible previous sandbox files that could cause conflicts
	if [ -d /usr/lib/sandbox ]; then
		if [ -f /etc/ld.so.preload ]; then
			mv /etc/ld.so.preload /etc/ld.so.preload_orig
			grep -v libsandbox.so /etc/ld.so.preload_orig > /etc/ld.so.preload
			rm /etc/ld.so.preload_orig
		fi
		
		rm -f ${ROOT}/usr/lib/portage/bin/ebuild.sh.orig
		rm -f ${ROOT}/usr/lib/portage/pym/portage.py.orig
		rm -f ${ROOT}/usr/bin/sandbox
		rm -rf ${ROOT}/usr/lib/sandbox
	fi

	#upgrade /var/db/pkg library
	cd ${ROOT}/var/db/pkg
	python ${ROOT}/usr/lib/portage/bin/db-update.py `find -name VIRTUAL`
}
