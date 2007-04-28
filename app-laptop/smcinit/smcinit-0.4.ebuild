# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/smcinit/smcinit-0.4.ebuild,v 1.5 2007/04/28 17:49:10 swegener Exp $

inherit eutils

IUSE=""

MY_PV="0.4-1"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A set of utilities to initialize a SMC-IRCC based IrDA subsystem on laptops where the BIOS does not handle it"
HOMEPAGE="http://irda.sourceforge.net/smcinit/"
SRC_URI="mirror://sourceforge/irda/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=sys-apps/pciutils-2.2.0-r1"

S=${WORKDIR}/${MY_P}

src_unpack()
{
	unpack ${A}
	cd ${S}

	#Patch for bug #117368 - compilation issues with new pciutils versions...
	epatch ${FILESDIR}/${P}-pciutils-2.2.0.patch
}

src_compile()
{
	econf || die "Configuration failed"
	emake CFLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install()
{
	# First goes the software...
	einstall PREFIX="${D}/usr" || die "Installation failed"

	# ...then documentation...
	dodoc AUTHORS CHANGELOG.Peri ChangeLog INSTALL README README.Peri README.Rob README.Tom
	dohtml RobMiller-irda.html

	# ...after that an init script...
	newinitd ${FILESDIR}/${PN}.initscript ${PN}

	# ...and finally its config file
	newconfd ${FILESDIR}/${PN}.conf ${PN}
}
