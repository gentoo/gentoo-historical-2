# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Christian Hubinger <a9806056@unet.univie.ac.at>
# $Header: /var/cvsroot/gentoo-x86/net-firewall/kmyfirewall/kmyfirewall-0.4.5.ebuild,v 1.1 2003/03/26 15:28:16 mholzer Exp $

inherit kde-base || die
need-kde 3

S=${WORKDIR}/${PN}

DESCRIPTION="Graphical KDE iptables configuration tool"
SRC_URI="ftp://ftp.sourceforge.net/pub/sourceforge/kmyfirewall/kmyfirewall-0.4.5-rc1.tar.gz"
HOMEPAGE="http://kmyfirewall.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="x86 sparc "
SLOT="0"


