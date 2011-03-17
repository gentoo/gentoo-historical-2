# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/openocd/openocd-0.5.0_pre20110317.ebuild,v 1.1 2011/03/17 12:47:29 hwoarang Exp $

EAPI="2"

inherit autotools eutils
if [[ ${PV} == "9999" ]] ; then
	inherit git
	KEYWORDS=""
	EGIT_REPO_URI="git://openocd.git.sourceforge.net/gitroot/openocd/openocd"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"
fi

DESCRIPTION="OpenOCD - Open On-Chip Debugger"
HOMEPAGE="http://openocd.berlios.de/web/"

LICENSE="GPL-2"
SLOT="0"
IUSE="blaster ftd2xx ftdi parport presto segger versaloon usb"
RESTRICT="strip" # includes non-native binaries

# libftd2xx is the default because it is reported to work better.
DEPEND="dev-lang/jimtcl
	usb? ( dev-libs/libusb )
	presto? ( dev-embedded/libftd2xx )
	ftd2xx? ( dev-embedded/libftd2xx )
	ftdi? ( dev-embedded/libftdi )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use ftdi && use ftd2xx ; then
		ewarn "You can only use one FTDI library at a time, so picking"
		ewarn "USE=ftdi (open source) over USE=ftd2xx (closed source)"
	fi
}

src_prepare() {
		[[ ${PV} != "9999" ]]  && sed -i -e "/@include version.texi/d" doc/${PN}.texi
		AT_NO_RECURSIVE=yes eautoreconf
}

src_configure() {
	if use usb;then
		myconf="${myconf} --enable-usbprog --enable-jlink --enable-rlink \
			--enable-vsllink --enable-arm-jtag-ew"
	fi
	[[ ${PV} != "9999" ]] && myconf="${myconf} --enable-maintainer-mode"
	# add explicitely the path to libftd2xx
	use ftd2xx && ! use ftdi && LDFLAGS="${LDFLAGS} -L/opt/$(get_libdir)"
	econf \
		--disable-werror \
		--disable-internal-jimtcl \
		--enable-amtjtagaccel \
		--enable-ep93xx \
		--enable-at91rm9200 \
		--enable-gw16012 \
		--enable-oocd_trace \
		$(use_enable blaster usb_flaster_libftdi) \
		$(use_enable ftdi ft2232_libftdi) \
		$(use ftdi || use_enable ftd2xx ft2232_ftd2xx) \
		$(use_enable parport) \
		$(use_enable presto presto_ftd2xx) \
		$(use_enable segger jlink) \
		$(use_enable versal0on vsllink) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO || die
	prepstrip "${D}"/usr/bin
}
