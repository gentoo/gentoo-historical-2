# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcsc-lite/pcsc-lite-1.5.5.ebuild,v 1.1 2009/08/02 06:25:57 arfrever Exp $

EAPI="2"

inherit multilib

DESCRIPTION="PC/SC Architecture smartcard middleware library"
HOMEPAGE="http://www.linuxnet.com/middle.html"

if [[ "${PV}" = "9999" ]]; then
	inherit subversion autotools
	ESVN_REPO_URI="svn://svn.debian.org/pcsclite/trunk"
	S="${WORKDIR}/trunk"
else
	STUPID_NUM="3082"
	MY_P="${PN}-${PV/_/-}"
	SRC_URI="http://alioth.debian.org/download.php/${STUPID_NUM}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="hal static usb"

RDEPEND="usb? ( virtual/libusb:0 )
	hal? ( sys-apps/hal )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if use hal && use usb; then
		ewarn "The usb and hal USE flags cannot be enabled at the same time"
		ewarn "Disabling the effect of USE=usb"
	fi
}

if [[ "${PV}" == "9999" ]]; then
	src_prepare() {
		S="${WORKDIR}/trunk/PCSC"
		cd "${S}"
		AT_M4DIR="m4" eautoreconf
	}
fi

src_configure() {
	local myconf
	if use hal; then
		myconf="--enable-libhal --disable-libusb"
	else
		myconf="--disable-libhal $(use_enable usb libusb)"
	fi

	econf \
		--docdir="/usr/share/doc/${PF}" \
		--enable-usbdropdir="/usr/$(get_libdir)/readers/usb" \
		${myconf} \
		$(use_enable static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	prepalldocs

	dodoc AUTHORS DRIVERS HELP README SECURITY ChangeLog

	newinitd "${FILESDIR}/pcscd-init" pcscd
	newconfd "${FILESDIR}/pcscd-confd" pcscd
}
