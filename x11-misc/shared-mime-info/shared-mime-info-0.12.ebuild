# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/shared-mime-info/shared-mime-info-0.12.ebuild,v 1.2 2003/09/13 13:28:29 lanius Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The Shared MIME-info Database specification."
HOMEPAGE="http://www.freedesktop.org"
SRC_URI="http://www.freedesktop.org/software/shared-mime-info/releases/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa amd64"

DEPEND=">=sys-apps/gawk-3.1.0
	>=dev-libs/glib-2.0.4
	>=dev-libs/libxml2-2.4.23"

src_install () {
	einstall || die
}
