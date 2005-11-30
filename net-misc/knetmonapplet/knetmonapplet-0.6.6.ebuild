# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knetmonapplet/knetmonapplet-0.6.6.ebuild,v 1.1.1.1 2005/11/30 09:55:02 chriswhite Exp $

inherit kde
need-kde 3

DESCRIPTION="Graphical network monitor for the KDE panel"
SRC_URI="http://ftp.kde.com/Computer_Devices/Networking/Monitoring/KnetmonApplet/${P}.tar.gz"
HOMEPAGE="http://perso.club-internet.fr/hftom/knetmonapplet/"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""

src_unpack() {
	kde_src_unpack

	rm -f $S/knetmon/uiconfig.{h,cpp,moc}
}
