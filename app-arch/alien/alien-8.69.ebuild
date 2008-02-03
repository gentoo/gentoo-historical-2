# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/alien/alien-8.69.ebuild,v 1.1 2008/02/03 11:20:03 drac Exp $

EAPI=1

inherit perl-app

DESCRIPTION="Converts between the rpm, dpkg, stampede slp, and slackware tgz file formats"
HOMEPAGE="http://kitenet.net/programs/alien"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86"
IUSE="+bzip2"

RDEPEND="app-arch/rpm
	app-arch/dpkg
	bzip2? ( app-arch/bzip2 )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

mydoc="TODO"

src_unpack() {
	perl-module_src_unpack
	sed -e s%'$(VARPREFIX)'%${D}% -e s%'$(PREFIX)'%${D}/usr%g \
		-i "${S}"/Makefile.PL || die "sed failed."
}
