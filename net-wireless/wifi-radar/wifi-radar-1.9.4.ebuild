# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wifi-radar/wifi-radar-1.9.4.ebuild,v 1.4 2006/08/23 13:47:22 s4t4n Exp $

inherit eutils

DESCRIPTION="WiFi Radar is a Python/PyGTK2 utility for managing WiFi profiles."
HOMEPAGE="http://www.bitbuilder.com/wifi_radar/"
SRC_URI="http://www.bitbuilder.com/wifi_radar/bins/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="svg"

RDEPEND=">=dev-python/pygtk-2.6.1
	>=net-wireless/wireless-tools-27-r1"

src_install ()
{
	dosbin wifi-radar
	dosed "s:/etc/conf.d:/etc:g" /usr/sbin/wifi-radar
	dobin wifi-radar.sh
	insinto /etc; doins wifi-radar.conf
	if use svg; then
		doicon wifi-radar.svg
		make_desktop_entry wifi-radar.sh "WiFi Radar" wifi-radar.svg Network
	else
		doicon wifi-radar.png
		make_desktop_entry wifi-radar.sh "WiFi Radar" wifi-radar.png Network
	fi
	doman wifi-radar.1 wifi-radar.conf.5
	dodoc AUTHORS ChangeLog README TODO WHISHLIST
}

pkg_postinst()
{
	einfo "Remember to edit configuration file /etc/wifi-radar.conf to suit your needs..."
	echo
	einfo "To use wifi-radar with a normal user (with sudo) add:"
	einfo "%users   ALL = /usr/sbin/wifi-radar"
	einfo ""
	einfo "in your /etc/sudoers then launch wifi-radar.sh"
	echo
}
