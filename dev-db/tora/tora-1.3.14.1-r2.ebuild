# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/tora/tora-1.3.14.1-r2.ebuild,v 1.3 2005/01/29 14:04:26 greg_g Exp $

inherit debug eutils kde-functions

IUSE="kde oracle debug"
DESCRIPTION="TOra - Toolkit For Oracle"
HOMEPAGE="http://www.globecom.se/tora/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-alpha-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64"

DEPEND=">=x11-libs/qt-3.0.0
	dev-lang/perl
	kde? ( >=kde-base/kdelibs-3.1 )"

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
	cd ${S}
	# http://sourceforge.net/tracker/index.php?func=detail&aid=1025950&group_id=16636&atid=316636
	epatch ${FILESDIR}/tora-1.3.14.1-triggers.diff

	# http://sourceforge.net/tracker/index.php?func=detail&aid=996061&group_id=16636&atid=316636

	epatch ${FILESDIR}/tora-1.3.14.1-invalidobjects.diff
	# http://sourceforge.net/tracker/index.php?func=detail&aid=1048530&group_id=16636&atid=316636
	epatch ${FILESDIR}/tora-1.3.14.1-race.patch

	# http://sourceforge.net/tracker/index.php?func=detail&aid=1055777&group_id=16636&atid=316636
	epatch ${FILESDIR}/tora-1.3.14.1-noblockquery.diff

	# http://sourceforge.net/tracker/index.php?func=detail&aid=1055783&group_id=16636&atid=316636
	epatch ${FILESDIR}/tora-1.3.14.1-oracleextract.diff

	# http://sourceforge.net/tracker/index.php?func=detail&aid=1057806&group_id=16636&atid=316636
	epatch ${FILESDIR}/tora-1.3.14.1-resultcontent-dtor.diff

	# http://sourceforge.net/tracker/index.php?func=detail&aid=1058979&group_id=16636&atid=316636
	epatch ${FILESDIR}/tora-1.3.14.1-tooltip-memleaks.diff

	# http://sourceforge.net/tracker/index.php?func=detail&aid=1059686&group_id=16636&atid=316636
	epatch ${FILESDIR}/tora-1.3.14.1-connection-memleak.diff
}

src_compile() {
	set-qtdir 3
	set-kdedir 3

	# Need to fake out Qt or we'll get sandbox problems
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	local myconf
	myconf="--prefix=/usr"
	myconf="$myconf --with-mono"

	use kde \
		&& myconf="$myconf --with-kde" \
		|| myconf="$myconf --without-kde"
	use oracle || myconf="$myconf --without-oracle"

	./configure $myconf || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	make install ROOT=${D}
	dodoc LICENSE.txt BUGS INSTALL NEWS README TODO
}
