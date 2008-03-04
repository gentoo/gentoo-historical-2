# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/jpilot-backup/jpilot-backup-0.53.ebuild,v 1.4 2008/03/04 12:22:51 armin76 Exp $

inherit multilib

DESCRIPTION="Backup plugin for jpilot"
SRC_URI="http://jasonday.home.att.net/code/backup/${P}.tar.gz"
HOMEPAGE="http://jasonday.home.att.net/code/backup/backup.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~ppc x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.6.10-r1
		>=app-pda/pilot-link-0.12.2
		>=app-pda/jpilot-0.99.9
		sys-libs/gdbm"
RDEPEND="${DEPEND}"

src_compile() {
	econf --enable-gtk2 || die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	make install DESTDIR="${D}" \
		libdir=/usr/$(get_libdir)/jpilot/plugins \
		|| die "install failed"
}
