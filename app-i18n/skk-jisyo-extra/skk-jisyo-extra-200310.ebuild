# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skk-jisyo-extra/skk-jisyo-extra-200310.ebuild,v 1.8 2005/01/01 14:41:36 eradicator Exp $

DESCRIPTION="Extra SKK dictionaries in plain text and cdb format"
HOMEPAGE="http://openlab.ring.gr.jp/skk/dic.html"
SRC_URI="mirror://gentoo/${PF}.tar.gz
	http://dev.gentoo.org/~usata/distfiles/${PF}.tar.gz"

# see each SKK-JISYO's header for detail
LICENSE="GPL-2 public-domain freedist"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"
IUSE=""

DEPEND="sys-apps/gawk
	|| ( dev-db/freecdb dev-db/cdb )"
RDEPEND=""

skkdic2cdb() {
	awk '/^[^;]/ {
		printf "+%d,%d:%s->%s\n", length($1), length($2), $1, $2
	} END {
		print ""
	} ' $1
}

src_compile() {
	for i in SKK-JISYO* ; do
		echo "Converting $i into $i.cdb ..."
		skkdic2cdb $i | cdbmake $i.cdb tmp.$i
	done || die
}

src_install() {
	insinto /usr/share/skk
	for i in SKK-JISYO* ; do
		doins $i || die
	done
	dodoc edict_doc.txt
}
