# (C) 2002 The TelemetryBox Corporation. http://telemetrybox.biz
# Distributed under the terms of the GNU General Public License v2
# Christoph Lameter, <christoph@lameter.com>, July 15, 2002
# $Header: /var/cvsroot/gentoo-x86/sys-apps/discover-data/discover-data-1.2002.05.23.ebuild,v 1.4 2002/10/19 01:52:44 vapier Exp $

DESCRIPTION="data for discover. list of pci ids. pnp ids etc."
SRC_URI="ftp://ftp.debian.org/debian/pool/main/d/discover-data/discover-data_1.2002.05.23-1.tar.gz"
HOMEPAGE="http://hackers.progeny.com/discover/"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="sys-apps/tar sys-apps/gzip"
RDEPEND="sys-apps/bash"

S=${WORKDIR}/discover-data-${P}-1

src_compile() {
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	todoc ChangeLog
}
