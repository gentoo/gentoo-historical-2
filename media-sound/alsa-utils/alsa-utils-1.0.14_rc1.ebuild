# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-utils/alsa-utils-1.0.14_rc1.ebuild,v 1.5 2007/01/05 17:20:33 flameeyes Exp $

inherit eutils autotools

MY_P="${P/_rc/rc}"

DESCRIPTION="Advanced Linux Sound Architecture Utils (alsactl, alsamixer, etc.)"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/utils/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh sparc x86"
IUSE="nls"

DEPEND=">=sys-libs/ncurses-5.1
	dev-util/dialog
	>=media-libs/alsa-lib-1.0.14_rc1"
RDEPEND="${DEPEND}
	sys-apps/pciutils"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.0.11_rc2-nls.patch"
	epatch "${FILESDIR}/${PN}-1.0.11_rc5-alsaconf-redirect.patch"
}

src_compile() {
	econf \
		$(use_enable nls) \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	local ALSA_UTILS_DOCS="ChangeLog README TODO
		seq/aconnect/README.aconnect
		seq/aseqnet/README.aseqnet"

	emake DESTDIR="${D}" install || die "Installation Failed"

	dodoc ${ALSA_UTILS_DOCS}
	newdoc alsamixer/README README.alsamixer

	newconfd "${FILESDIR}/alsasound.confd" alsasound
	insinto /etc/modules.d
	newins "${FILESDIR}/alsa-modules.conf-rc" alsa
	newinitd "${FILESDIR}/alsasound-1.0.10_rc2" alsasound
}

pkg_postinst() {
	echo
	elog "The alsasound initscript is now provided by alsa-utils"
	elog "instead of alsa-driver for compatibility with kernel-sources"
	elog "which provide ALSA internally."
	echo
	elog "To take advantage of this, and automate the process of"
	elog "loading and unloading the ALSA sound drivers as well as"
	elog "storing and restoring sound-card mixer levels you should"
	elog "add alsasound to the boot runlevel. You can do this as"
	elog "root like so:"
	elog "	# rc-update add alsasound boot"
	echo
	elog "You will also need to edit the file /etc/modules.d/alsa"
	elog "and run modules-update. You can do this like so:"
	elog "	# nano -w /etc/modules.d/alsa && modules-update"
	echo

	if use sparc; then
		ewarn "Old versions of alsa-drivers had a broken snd-ioctl32 module"
		ewarn "which causes sparc64 machines to lockup on such tasks as"
		ewarn "changing the volume.	 Because of this, it is VERY important"
		ewarn "that you do not use the snd-ioctl32 modules contained in"
		ewarn "development-sources or <=gentoo-dev-sources-2.6.7-r14.  Doing so"
		ewarn "may result in an unbootable system if you start alsasound at boot."
	fi
}
