# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-4.0.14-r3.ebuild,v 1.15 2005/07/10 20:59:39 swegener Exp $

inherit eutils gnuconfig db

S="${WORKDIR}/${P}/build_unix"
DESCRIPTION="Berkeley DB"
SRC_URI="ftp://ftp.sleepycat.com/releases/${P}.tar.gz"
HOMEPAGE="http://www.sleepycat.com"
IUSE="tcltk java doc"
SLOT="4"
LICENSE="DB"
KEYWORDS="alpha amd64 ~hppa ia64 m68k ~mips ppc ppc64 ~sparc x86"

DEPEND="tcltk? ( dev-lang/tcl )
	java? ( virtual/jdk )"

RDEPEND="tcltk? ( dev-lang/tcl )
	java? ( virtual/jre )"

src_unpack() {
	unpack ${A}

	# Get db to link libdb* to correct dependencies ... for example if we use
	# NPTL or NGPT, db detects usable mutexes, and should link against
	# libpthread, but does not do so ...
	# <azarah@gentoo.org> (23 Feb 2003)
	cd ${WORKDIR}/${P}; epatch ${FILESDIR}/${P}-fix-dep-link.patch
	epatch ${FILESDIR}/${PN}-4.1.25-java.patch

	cd ${WORKDIR} ; epatch ${FILESDIR}/${P}-jarlocation.patch
}

src_compile() {
	addwrite /proc/self/maps
	# gnuconfig doesn't work if ${S} points to build_unix, so we
	# change it temporarily
	if use mips; then
		einfo "Updating config.{guess,sub} for mips"
		local OLDS="${S}"
		S="${WORKDIR}/${P}/dist"
		gnuconfig_update
		S="${OLDS}"
	fi

	local myconf="--enable-rpc"

	use java \
		&& myconf="${myconf} --enable-java" \
		|| myconf="${myconf} --disable-java"

	use tcltk \
		&& myconf="${myconf} --enable-tcl --with-tcl=/usr/$(get_libdir)" \
		|| myconf="${myconf} --disable-tcl"

	if use java && [ -n "${JAVAC}" ]; then
		export PATH=`dirname ${JAVAC}`:${PATH}
		export JAVAC=`basename ${JAVAC}`
	fi

	../dist/configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--libdir=/usr/$(get_libdir) \
		--enable-compat185 \
		--enable-cxx \
		--with-uniquename \
		${myconf} || die

#	disable posix mutexes as they are not available in linuxthreads from
#	the standard profile and they should be autodetected if available
#
#		--enable-posixmutexes \

	emake -j1 || die
}

src_install () {

	einstall libdir="${D}/usr/$(get_libdir)" || die

	db_src_install_usrbinslot

	db_src_install_headerslot

	db_src_install_doc

	db_src_install_usrlibcleanup

	dodir /usr/sbin
	mv ${D}/usr/bin/berkeley_db_svc ${D}/usr/sbin/berkeley_db40_svc
}

pkg_postinst () {
	db_fix_so
}

pkg_postrm () {
	db_fix_so
}
