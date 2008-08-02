# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-utils/alsa-utils-1.0.17.ebuild,v 1.1 2008/08/02 21:00:32 betelgeuse Exp $

inherit eutils autotools

MY_P="${P/_rc/rc}"

DESCRIPTION="Advanced Linux Sound Architecture Utils (alsactl, alsamixer, etc.)"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/utils/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="nls midi minimal"

DEPEND=">=sys-libs/ncurses-5.1
	dev-util/dialog
	>=media-libs/alsa-lib-${PV}"
RDEPEND="${DEPEND}
	virtual/modutils
	!minimal? ( sys-apps/pciutils )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use midi && ! built_with_use --missing true media-libs/alsa-lib midi; then
		eerror ""
		eerror "To be able to build alsa-utils with midi support you need"
		eerror "to have built media-libs/alsa-lib with midi USE flag."
		die "Missing midi USE flag on media-libs/alsa-lib"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.0.11_rc2-nls.patch"
	epatch "${FILESDIR}/${PN}-1.0.11_rc5-alsaconf-redirect.patch"
	epatch "${FILESDIR}/${PN}-1.0.14-alsaconf-modules-update.patch"
	epatch "${FILESDIR}/${PN}-1.0.17-seq.patch"

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf $(use_enable nls) \
		$(use_enable midi sequencer) \
		|| die "configure failed"

	emake || die "make failed"
}

pkg_preinst() {
	if [[ -a /etc/modules.d/alsa ]] && [[ ! -a /etc/modprobe.d/alsa ]]; then
		elog "Moving old alsa configuration in modules.d to new"
		elog "location in modprobe.d in /etc/"
		mv "${ROOT}/etc/modules.d/alsa" "${ROOT}/etc/modprobe.d/alsa"
	fi
}

src_install() {
	local ALSA_UTILS_DOCS="ChangeLog README TODO
		seq/aconnect/README.aconnect
		seq/aseqnet/README.aseqnet"

	emake DESTDIR="${D}" install || die "Installation Failed"

	dodoc ${ALSA_UTILS_DOCS} || die
	newdoc alsamixer/README README.alsamixer || die

	newinitd "${FILESDIR}/alsasound.initd" alsasound
	newconfd "${FILESDIR}/alsasound.confd" alsasound
	insinto /etc/modprobe.d
	newins "${FILESDIR}/alsa-modules.conf-rc" alsa

	keepdir /var/lib/alsa
}

pkg_postinst() {
	echo
	elog "To take advantage of the init script, and automate the process of"
	elog "loading and unloading the ALSA sound drivers as well as"
	elog "storing and restoring sound-card mixer levels you should"
	elog "add alsasound to the boot runlevel. You can do this as"
	elog "root like so:"
	elog "	# rc-update add alsasound boot"
	echo
	if use minimal; then
		ewarn "The minimal use flag disables the dependency on pciutils that"
		ewarn "is needed by alsaconf at runtime."
	fi
}
