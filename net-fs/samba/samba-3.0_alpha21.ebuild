# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/samba/samba-3.0_alpha21.ebuild,v 1.1 2003/02/23 17:45:05 woodchip Exp $

inherit eutils

IUSE="kerberos mysql xml acl cups ldap pam python"
IUSE="${IUSE} oav"

DESCRIPTION="SAMBA is a suite of SMB and CIFS client/server programs for UNIX"
HOMEPAGE="http://www.samba.org"

VSCAN_VER=0.3.2
VSCAN_MODS=${VSCAN_MODS:=fprot mks openantivirus sophos trend icap} #kapersky
# To build the "kapersky" plugin, the kapersky lib must be installed.

S=${WORKDIR}/${PN}-${PV/_/}
PATCHBALL=1
SRC_URI="oav? mirror://sourceforge/openantivirus/${PN}-vscan-${VSCAN_VER}.tar.bz2
	http://us3.samba.org/samba/ftp/alpha/${PN}-${PV/_/}.tar.bz2
	mirror://gentoo/${PN}-${PV/_/}-patches-${PATCHBALL}.tar.bz2"

DEPEND="sys-devel/autoconf sys-libs/readline dev-libs/popt
	kerberos? app-crypt/krb5
	mysql? ( dev-db/mysql sys-libs/zlib )
	xml? ( dev-libs/libxml2 sys-libs/zlib )
	acl? sys-apps/acl
	cups? net-print/cups
	ldap? =net-nds/openldap-2*
	pam? >=sys-libs/pam-0.72
	python? dev-lang/python"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

src_unpack() {
	local i
	unpack ${A} || die
	cd ${S} || die

	# Apply patches.
	for i in ${WORKDIR}/${PN}-${PV/_/}-patches-${PATCHBALL}/*.patch
	do
		epatch $i
	done

	# For clean docs packaging sake.
	cp -a ${S}/examples ${S}/examples.bin

	# Prep samba-vscan source.
	if use oav; then
		cp -a ${WORKDIR}/${PN}-vscan-${VSCAN_VER} examples.bin/VFS
		cd examples.bin/VFS/${PN}-vscan-${VSCAN_VER}/include

		sed -e "s%^\(# define SAMBA_VERSION_MAJOR\).*%\1 3%" \
			vscan-global.h >vscan-global.h.3
		mv -f vscan-global.h.3 vscan-global.h
	fi

	cd ${S}/source
	autoconf || die
}

src_compile() {
	local i myconf
	use acl && myconf="--with-acl-support" \
		||  myconf="--without-acl-support"

	use pam && myconf="${myconf} --with-pam --with-pam_smbpass" \
		|| myconf="${myconf} --without-pam --without-pam_smbpass"

	use cups && myconf="${myconf} --enable-cups" \
		|| myconf="${myconf} --disable-cups"

	use ldap && myconf="${myconf} --with-ldap" \
		|| myconf="${myconf} --without-ldap"
	#myconf="${myconf} --with-ldapsam" #this is for old samba 2.x compat
	myconf="${myconf} --without-ldapsam"

	use kerberos && myconf="${myconf} --with-ads" \
		|| myconf="${myconf} --without-ads"

	#this isnt building at the moment.. not for me anyhow :\
	use python && myconf="${myconf} --with-python" \
		|| myconf="${myconf} --without-python"

	einfo "\$myconf is: $myconf"
	cd ${S}/source
	./configure \
		--with-fhs \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-manpages-langs=en \
		--with-privatedir=/etc/samba/private \
		--with-sendfile-support \
		--without-spinlocks \
		--with-libsmbclient \
		--with-automount \
		--with-smbmount \
		--with-winbind \
		--with-quotas \
		--with-tdbsam \
		--with-syslog \
		--with-utmp \
		--host=${CHOST} ${myconf} || die

	# Compile main SAMBA pieces.
	make everything wins || die
	make torture rpctorture
	# rpctorture didnt build

	if use mysql
	then
		make bin/pdb_mysql.so || die
	fi
	if use xml
	then
		make bin/pdb_xml.so || die
	fi
	if use python
	then
		# this seems to be in-flux atm or something...
		make python_ext
	fi

	# Build selected samba-vscan plugins.
	use oav && \
	for i in ${VSCAN_MODS}
	do
		cd ${S}/examples.bin/VFS/${PN}-vscan-${VSCAN_VER}/$i
		make USE_INCLMKSDLIB=1 #needed for the mks build
		assert "problem building $i vscan module"
	done
}

#the python stuff isnt installed yet..
src_install() {
	# Install standard binary files.
	for i in smbclient net smbspool testparm testprns smbstatus \
		smbcontrol smbtree tdbbackup wbinfo smbpasswd rpcclient \
		smbcacls smbmount smbmnt smbumount nmblookup pdbedit \
		smbgroupedit \
		debug2html smbfilter talloctort #smbsh
	do
		exeinto /usr/bin
		doexe source/bin/${i}
	done

	# TORTURE_PROGS / Testing stuff, if they built they will come.
	for i in smbtorture msgtest masktest locktest locktest2 \
		nsstest vfstest rpctorture
	do
		if [ -x source/bin/${i} ]
		then
			exeinto /usr/bin
			doexe source/bin/${i}
		fi
	done

	# Installing these two setuid-root allows users to (un)mount smbfs.
	fperms 4755 /usr/bin/smbumount
	fperms 4755 /usr/bin/smbmnt

	# Install server binaries.
	for i in smbd nmbd swat wrepld winbindd
	do
		exeinto /usr/sbin
		doexe source/bin/${i}
	done

	# Libraries.
	exeinto /usr/lib
	#broken for a while now with some wacky glibc issue
	#doexe source/bin/smbwrapper.so
	doexe source/bin/libsmbclient.so
	insinto /usr/lib
	doins source/bin/libsmbclient.a
	insinto /usr/include
	doins source/include/libsmbclient.h
	exeinto /lib/security
	doexe source/nsswitch/pam_winbind.so
	use pam && doexe source/bin/pam_smbpass.so

	# nsswitch library extension files.
	for i in wins winbind
	do
		exeinto /lib
		doexe source/nsswitch/libnss_${i}.so
	done
	# make link for wins and winbind resolvers..
	( cd ${D}/lib ; ln -s libnss_wins.so libnss_wins.so.2 )
	( cd ${D}/lib ; ln -s libnss_winbind.so libnss_winbind.so.2 )

	# VFS plugin modules.
	exeinto /usr/lib/samba/vfs
	doexe source/bin/vfs_audit.so
	doexe source/bin/vfs_netatalk.so
	doexe source/bin/vfs_recycle.so
	use oav && \
	doexe examples.bin/VFS/${PN}-vscan-${VSCAN_VER}/*/vscan-*.so

	# Install passdb modules.
	exeinto /usr/lib/samba
	use mysql && doexe source/bin/pdb_mysql.so
	use xml && doexe source/bin/pdb_xml.so

	# Install codepage data files.
	insinto /usr/share/samba
	doins source/codepages/*.dat


	# Install SWAT helper files.
	for i in swat/help/*.html docs/htmldocs/*.html
	do
		insinto /usr/share/swat/help
		doins ${i}
	done
	for i in swat/images/*.gif
	do
		insinto /usr/share/swat/images
		doins ${i}
	done
	for i in swat/include/*.html
	do
		insinto /usr/share/swat/include
		doins ${i}
	done


	# Install the O'Reilly "Using Samba" book.
	for i in docs/htmldocs/using_samba/*.html
	do
		insinto /usr/share/swat/using_samba
		doins ${i}
	done
	for i in docs/htmldocs/using_samba/gifs/*.gif
	do
		insinto /usr/share/swat/using_samba/gifs
		doins ${i}
	done
	for i in docs/htmldocs/using_samba/figs/*.gif
	do
		insinto /usr/share/swat/using_samba/figs
		doins ${i}
	done


	# Install man pages.
	doman docs/manpages/*

	# SAMBA has a lot of docs, so this just basically
	# installs them all!  We don't want two copies of
	# the book or manpages though, so:
	rm -rf docs/htmldocs/using_samba docs/manpages

	dodoc COPYING Manifest README Roadmap WHATSNEW.txt
	docinto full_docs
	cp -a docs/* ${D}/usr/share/doc/${PF}/full_docs
	docinto examples
	cp -a examples/* ${D}/usr/share/doc/${PF}/examples
	prepalldocs
	# keep this next line *after* prepalldocs!
	dosym /usr/share/swat/using_samba /usr/share/doc/${PF}/using_samba
	# and we should unzip the html docs..
	gunzip ${D}/usr/share/doc/${PF}/full_docs/faq/*
	gunzip ${D}/usr/share/doc/${PF}/full_docs/htmldocs/*
	if use oav; then
		docinto ${PN}-vscan-${VSCAN_VER}
		cd ${WORKDIR}/${PN}-vscan-${VSCAN_VER}
		dodoc AUTHORS COPYING ChangeLog FAQ INSTALL NEWS README TODO
		dodoc */*.conf
	fi
	# I guess this isnt really a userpriv buglet... the 'dodoc'
	# script really needs a recursive feature...
	chown -R root.root ${D}/usr/share/doc/${PF}

	# link /usr/bin/smbmount to /sbin/mount.smbfs which allows it
	# to work transparently with the standard 'mount' command..
	dodir /sbin
	dosym /usr/bin/smbmount /sbin/mount.smbfs

	# make the smb backend symlink for cups printing support..
	if use cups; then
		dodir /usr/lib/cups/backend
		dosym /usr/bin/smbspool /usr/lib/cups/backend/smb
	fi


	# Now the config files.
	insinto /etc/openldap/schema
	doins examples/LDAP/samba.schema

	insinto /etc
	dodoc ${FILESDIR}/nsswitch.conf-winbind
	doins ${FILESDIR}/nsswitch.conf-wins

	insinto /etc/samba
	doins ${FILESDIR}/smbusers
# need to update this one! :)
	doins ${FILESDIR}/smb.conf.example
	doins ${FILESDIR}/lmhosts
	doins ${FILESDIR}/recycle.conf

	insinto /etc/pam.d
	newins ${FILESDIR}/samba.pam samba
	doins ${FILESDIR}/system-auth-winbind

	exeinto /etc/init.d
	newexe ${FILESDIR}/samba-init samba
# this one looks funny
	newexe ${FILESDIR}/winbind-init winbind

	insinto /etc/xinetd.d
	newins ${FILESDIR}/swat.xinetd swat
}

pkg_postinst() {
	# touch /etc/samba/smb.conf so that people installing samba just
	# to mount smb shares don't get annoying warnings all the time..
	if [ ! -e ${ROOT}/etc/samba/smb.conf ] ; then
		touch ${ROOT}/etc/samba/smb.conf
	fi

	# empty dirs..
	install -m0700 -o root -g root -d ${ROOT}/etc/samba/private
	install -m1777 -o root -g root -d ${ROOT}/var/spool/samba
	install -m0755 -o root -g root -d ${ROOT}/var/log/samba
	install -m0755 -o root -g root -d ${ROOT}/var/run/samba
	install -m0755 -o root -g root -d ${ROOT}/var/cache/samba
	install -m0755 -o root -g root -d ${ROOT}/var/lib/samba/{netlogon,profiles}
	install -m0755 -o root -g root -d \
		${ROOT}/var/lib/samba/printers/{W32X86,WIN40,W32ALPHA,W32MIPS,W32PPC}
}
