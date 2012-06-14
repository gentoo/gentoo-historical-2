# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/skype/skype-4.0.0.7-r1.ebuild,v 1.2 2012/06/14 21:08:27 ssuominen Exp $

EAPI=4
inherit eutils gnome2-utils pax-utils unpacker

DESCRIPTION="An P2P Internet Telephony (VoiceIP) client"
HOMEPAGE="http://www.skype.com/"
SKYPE_URI="http://download.${PN}.com/linux"
# TODO: skype-4.0.0.7.tar.bz2 is now present in the same SRC_URI, flip it
# on the next time fixing something else here
SRC_URI="amd64? ( ${SKYPE_URI}/${PN}-debian_${PV}-1_amd64.deb )
	x86? ( ${SKYPE_URI}/${PN}-debian_${PV}-1_i386.deb )"

LICENSE="${P}-copyright ${P}-third-party_attributions.txt"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pax_kernel"

QA_PREBUILT=opt/bin/${PN}
RESTRICT="mirror strip" #299368

EMUL_X86_VER=20120127

RDEPEND="virtual/ttf-fonts
	amd64? (
		>=app-emulation/emul-linux-x86-qtlibs-${EMUL_X86_VER}
		>=app-emulation/emul-linux-x86-soundlibs-${EMUL_X86_VER}
		>=app-emulation/emul-linux-x86-xlibs-${EMUL_X86_VER}
	)
	x86? (
		media-libs/alsa-lib
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXScrnSaver
		x11-libs/libXv
		x11-libs/qt-core:4
		x11-libs/qt-dbus:4
		x11-libs/qt-gui:4[accessibility,dbus]
	)"

S=${WORKDIR}

src_compile() {
	local langdir=usr/share/${PN}/lang
	type -P lrelease >/dev/null && lrelease ${langdir}/*.ts
	rm -f ${langdir}/*.ts
}

src_install() {
	into /opt
	dobin usr/bin/${PN}
	fowners root:audio /opt/bin/${PN}

	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/system.d/${PN}.conf

	insinto /usr/share
	doins -r usr/share/${PN}

	dodoc usr/share/doc/${PN}/README

	doicon -s 48 usr/share/icons/${PN}.png
	make_desktop_entry ${PN} 'Skype VoIP' ${PN} 'Network;InstantMessaging;Telephony'

	if use pax_kernel; then
		pax-mark Cm "${ED}"/opt/bin/${PN} || die
		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
		eqawarn "${PN} under a PaX enabled kernel.  To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi
}

pkg_preinst() {
	gnome2_icon_savelist

	# Temporary workaround until Portage is fixed for upgrade path from 2.x
	# series:
	# "One or more symlinks to directories have been preserved in order to
	# ensure that files installed via these symlinks remain accessible."
	rm -rf "${EROOT}"/usr/share/${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update

	# http://bugs.gentoo.org/360815
	elog "For webcam support, see \"LD_PRELOAD\" section of \"README.lib\" document provided by"
	elog "media-libs/libv4l package and \"README\" document of this package."
	if use amd64; then
		elog "You can install app-emulation/emul-linux-x86-medialibs package for the 32bit"
		elog "libraries from the media-libs/libv4l package."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
