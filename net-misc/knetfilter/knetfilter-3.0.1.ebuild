# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knetfilter/knetfilter-3.0.1.ebuild,v 1.5 2002/07/11 06:30:48 drobbins Exp $

inherit kde-base || die

need-kde 3

S=${WORKDIR}/${P}
LICENSE="GPL-2"
DESCRIPTION="Manage Iptables firewalls with this KDE app"
SRC_URI="http://expansa.sns.it:8080/knetfilter/${P}.tar.gz"
HOMEPAGE="http://expansa.sns.it:8080/knetfilter/"
KEYWORDS="x86"

newdepend ">=sys-apps/iptables-1.2.5"

src_unpack() {
    base_src_unpack
    kde_sandbox_patch ${S}/src
}
