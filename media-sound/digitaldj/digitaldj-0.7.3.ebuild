# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/digitaldj/digitaldj-0.7.3.ebuild,v 1.4 2004/02/22 22:28:39 agriffis Exp $

DESCRIPTION="A SQL-based mp3-player frontend designed to work with Grip"
HOMEPAGE="http://www.nostatic.org/ddj/"
SRC_URI="http://www.nostatic.org/ddj/${P}.tar.gz"
LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~hppa ~mips ~sparc ~x86"
IUSE=""
DEPEND="dev-db/mysql
	gnome-base/libghttp
	media-libs/gdk-pixbuf
	media-sound/grip
	>=x11-libs/gtk+-1.2"

src_compile() {
	econf --disable-lirc
	emake || die
}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	einfo "To create the DDJ database run"
	einfo "	ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
}

pkg_config() {
	local sql=`mktemp digitaldj.XXXXXXXXXX` || die "mktemp failed"
	echo 'CREATE DATABASE IF NOT EXISTS ddj_mp3;' >> ${sql}
	echo 'GRANT SELECT, INSERT, UPDATE, DELETE ON ddj_mp3.* TO ddj@localhost;' >> ${sql}
	echo 'USE ddj_mp3;' >> ${sql}
	sed -e 's/^\(CREATE TABLE\)/\1 IF NOT EXISTS/g' ${ROOT}/usr/share/digitaldj/0-2.sql >> ${sql}
	less ${sql}
	echo "Type in your MySQL root password:"
	mysql -u root -p < ${sql}
	rm -f ${sql}
}
