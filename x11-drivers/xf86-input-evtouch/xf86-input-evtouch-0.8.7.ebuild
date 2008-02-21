# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-evtouch/xf86-input-evtouch-0.8.7.ebuild,v 1.3 2008/02/21 22:52:41 cardoe Exp $

SNAPSHOT="yes"
XDPVER=-1

inherit x-modular autotools

DESCRIPTION="Input driver for Linux event touchscreens"
HOMEPAGE="http://www.conan.de/touchscreen/evtouch.html"
SRC_URI="http://www.conan.de/touchscreen/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="<x11-base/xorg-server-1.4"
DEPEND="${RDEPEND}
	|| ( >=sys-kernel/linux-headers-2.6 >=sys-kernel/mips-headers-2.6 )
	x11-proto/inputproto
	x11-proto/randrproto
	x11-proto/xproto"

PATCHES="${FILESDIR}/${PN}-evcalibrate-path.patch"
CONFIGURE_OPTIONS="--enable-evcalibrate --enable-udevinstall"
DOCS="README README.calibration TODO"

pkg_postinst() {
	einfo
	elog "To enable this driver, add the following to xorg.conf:"
	elog "Section \"InputDevice\""
	elog "    Identifier \"touchscreen\""
	elog "    Driver \"evtouch\""
	elog "    Option \"Device\" \"/dev/input/evtouch_event\""
	elog "    Option \"DeviceName\" \"touchscreen\""
	elog "    Option \"ReportingMode\" \"Raw\""
	elog "    Option \"Emulate3Buttons\""
	elog "    Option \"Emulate3Timeout\" \"50\""
	elog "    Option \"SendCoreEvents\" \"On\""
	elog "    Option \"Calibrate\" \"1\""
	elog "EndSection"
	elog
	elog "Then with X not running run: "
	elog "$ calibrate.sh"
	elog
	elog "Once you complete the calibration, you'll have: out.txt"
	elog "Merge the lines found in there into the InputDevice"
	elog "section you created earlier and remove the Calibrate"
	elog "line. Your touch screen should work now."
	elog
	elog "More info, read README.calibrate and check out:"
	elog "${HOMEPAGE}"
}
