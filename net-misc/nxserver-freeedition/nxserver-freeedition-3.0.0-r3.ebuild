# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxserver-freeedition/nxserver-freeedition-3.0.0-r3.ebuild,v 1.3 2007/09/19 14:51:03 voyageur Exp $

inherit eutils

DESCRIPTION="Free edition NX server from NoMachine"
HOMEPAGE="http://www.nomachine.com/"
SRC_URI="amd64? ( http://64.34.161.181/download/3.0.0/Linux/FE/nxserver-${PV}-69.x86_64.tar.gz )
	x86? ( http://64.34.161.181/download/3.0.0/Linux/FE/nxserver-${PV}-69.i386.tar.gz )"

LICENSE="nomachine"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND="=net-misc/nxnode-3.0*
	!net-misc/nxserver-freenx
	!net-misc/nxserver-2xterminalserver"
RDEPEND="${DEPEND}
	media-fonts/font-misc-misc
	media-fonts/font-cursor-misc
	x11-apps/xauth"

S="${WORKDIR}"/NX

pkg_preinst()
{
	enewuser nx -1 -1 /usr/NX/home/nx
}

src_unpack()
{
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/nxserver-3.0.0-r3-setup.patch
}

src_install()
{
	# we install nxserver into /usr/NX, to make sure it doesn't clash
	# with libraries installed for FreeNX

	into /usr/NX
	dobin bin/nxserver

	dodir /usr/NX/etc/keys
	insinto /usr/NX/etc
	doins etc/administrators.db.sample
	doins etc/guests.db.sample
	doins etc/passwords.db.sample
	doins etc/profiles.db.sample
	doins etc/users.db.sample
	doins etc/server.lic.sample

	newins etc/server-debian.cfg.sample server-gentoo.cfg.sample

	cp -R home ${D}/usr/NX || die "Unable to install home folder"
	cp -R lib ${D}/usr/NX || die "Unable to install lib folder"
	cp -R scripts ${D}/usr/NX || die "Unable to install scripts folder"
	cp -R share "${D}"/usr/NX || die "Unable to install share folder"
	cp -R var "${D}"/usr/NX || die "Unable to install var folder"

	newinitd "${FILESDIR}"/nxserver-2.1.0-init nxserver
}

pkg_postinst ()
{
	usermod -s /usr/NX/bin/nxserver nx || die "Unable to set login shell of nx user!!"
	usermod -d /usr/NX/home/nx nx || die "Unable to set home directory of nx user!!"

	# only run install when no configuration file is found
	if [ -f /usr/NX/etc/server.cfg ]; then
		einfo "Running NoMachine's update script"
		"${ROOT}"/usr/NX/scripts/setup/nxserver --update || die "Update script failed"
	else
		einfo "Running NoMachine's setup script"
		"${ROOT}"/usr/NX/scripts/setup/nxserver --install || die "Installation script failed"
	fi

	elog "Remember to add nxserver to your default runlevel"
}
