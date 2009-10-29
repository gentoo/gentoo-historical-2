# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatasmart/libatasmart-0.16.ebuild,v 1.1 2009/10/29 23:50:37 eva Exp $

EAPI="2"

DESCRIPTION="Lean and small library for ATA S.M.A.R.T. hard disks"
HOMEPAGE="http://0pointer.de/blog/projects/being-smart.html"
SRC_URI="http://0pointer.de/public/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-fs/udev
	!!sys-apps/libatasmart"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README || die "dodoc failed"
}
