# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/tora/tora-1.3.23.ebuild,v 1.1 2008/06/16 18:21:35 dertobi123 Exp $

inherit eutils kde-functions

IUSE="kde oracle debug oci8-instant-client xinerama"
DESCRIPTION="TOra - Toolkit For Oracle"
HOMEPAGE="http://tora.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-1-3-end-of-life.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

RDEPEND="${DEPEND}
	xinerama? ( x11-libs/libXinerama )"

DEPEND="=x11-libs/qt-3*
	dev-lang/perl
	<x11-libs/qscintilla-2.1
	kde? ( >=kde-base/kdelibs-3.1
		   kde-base/arts )
	xinerama? ( x11-proto/xineramaproto )
	oci8-instant-client? ( dev-db/oracle-instantclient-basic )"

S="${WORKDIR}/${PN}-1-3-end-of-life"

pkg_setup() {
	if use oracle && [ -z "$ORACLE_HOME" ] ; then
		eerror "ORACLE_HOME variable is not set."
		eerror
		eerror "You must install Oracle >= 8i client for Linux in"
		eerror "order to compile TOra with Oracle support."
		eerror
		eerror "Otherwise specify -oracle in your USE variable."
		eerror
		eerror "You can download the Oracle software from"
		eerror "http://otn.oracle.com/software/content.html"
		die
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-gcc43.patch"
}

src_compile() {
	set-qtdir 3
	set-kdedir 3

	# Need to fake out Qt or we'll get sandbox problems
	REALHOME="$HOME"
	mkdir -p "$T"/fakehome/.kde
	mkdir -p "$T"/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	local myconf
	myconf="${myconf} $(use_with kde)"
	myconf="${myconf} $(use_with oracle)"
	myconf="${myconf} $(use_with xinerama)"

	if use oci8-instant-client; then
		myconf="$myconf --with-instant-client"
	fi

	myconf="$myconf --with-qt-dir=/usr/qt/3"

	#./configure $myconf || die "configure failed"
	econf $myconf || die "configure failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}"
	dodoc BUGS INSTALL NEWS README TODO

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop
	insinto /usr/share/pixmaps
	doins "${FILESDIR}"/${PN}.png
}
