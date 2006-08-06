# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/autoproject/autoproject-0.20.ebuild,v 1.1 2006/08/06 00:07:11 vapier Exp $

inherit eutils

DEB_VER=3
DESCRIPTION="Used to start a programming project using autoconf, automake, and optionally a command line parser generator"
HOMEPAGE="http://packages.debian.org/unstable/devel/autoproject"
SRC_URI="mirror://debian/pool/main/a/autoproject/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/a/autoproject/${PN}_${PV}-${DEB_VER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="sys-devel/automake
	sys-devel/autoconf"

src_unpack() {
	unpack ${A}
	epatch ${PN}_${PV}-${DEB_VER}.diff
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS NEWS README TODO ChangeLog
}
