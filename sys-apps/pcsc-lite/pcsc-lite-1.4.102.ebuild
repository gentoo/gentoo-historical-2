# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcsc-lite/pcsc-lite-1.4.102.ebuild,v 1.1 2008/08/30 06:54:13 dragonheart Exp $

inherit multilib

DESCRIPTION="PC/SC Architecture smartcard middleware library"
HOMEPAGE="http://www.linuxnet.com/middle.html"

if [[ "${PV}" = "9999" ]]; then
	inherit subversion autotools
	ESVN_REPO_URI="svn://svn.debian.org/pcsclite/trunk"
	S="${WORKDIR}/trunk"
else
	STUPID_NUM="2479"
	MY_P="${PN}-${PV/_/-}"
	SRC_URI="http://alioth.debian.org/download.php/${STUPID_NUM}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="static debug usb hal"

RDEPEND="usb? ( dev-libs/libusb )
	hal? ( sys-apps/hal )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	if [ "${PV}" != "9999" ]; then
		unpack ${A}
		cd "${S}"
	else
		subversion_src_unpack
		S="${WORKDIR}/trunk/PCSC"
		cd "${S}"
		AT_M4DIR="m4" eautoreconf
	fi
}

src_compile() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--enable-usbdropdir="/usr/$(get_libdir)/readers/usb" \
		--enable-muscledropdir="/usr/share/pcsc/services" \
		--enable-runpid="/var/run/pcscd.pid" \
		$(use_enable hal libhal) \
		$(use_enable usb libusb) \
		$(use_enable debug) \
		$(use_enable static) \
		|| die "configure failed"
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	prepalldocs

	dodoc AUTHORS DRIVERS HELP README SECURITY ChangeLog

	newinitd "${FILESDIR}/pcscd-init" pcscd
	newconfd "${FILESDIR}/pcscd-confd" pcscd
}
