# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skk-jisyo-extra/skk-jisyo-extra-200307.ebuild,v 1.1 2003/07/16 17:08:56 usata Exp $

IUSE=""

DESCRIPTION="Extra SKK dictionaries in plain text and cdb format"
HOMEPAGE="http://openlab.ring.gr.jp/skk/dic.html"
SRC_PATH="http://dev.gentoo.org/~usata/distfiles"
SRC_URI="${SRC_PATH}/SKK-JISYO.ML.${PV}.gz
	${SRC_PATH}/SKK-JISYO.JIS2.${PV}.gz
	${SRC_PATH}/SKK-JISYO.JIS3_4.${PV}.gz
	${SRC_PATH}/SKK-JISYO.edict.${PV}.tar.gz
	${SRC_PATH}/SKK-JISYO.geo.${PV}.gz
	${SRC_PATH}/SKK-JISYO.pubdic+.${PV}.gz
	${SRC_PATH}/zipcode.${PV}.tar.gz
	${SRC_PATH}/SKK-JISYO.assoc.${PV}.gz
	${SRC_PATH}/SKK-JISYO.okinawa.${PV}.gz
	${SRC_PATH}/SKK-JISYO.law.${PV}.gz
	${SRC_PATH}/SKK-JISYO.jinmei.${PV}.gz
	${SRC_PATH}/SKK-JISYO.mazegaki.${PV}.gz"

# see each SKK-JISYO's header for detail
LICENSE="GPL-2 public-domain freedist"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="sys-apps/gawk
	|| ( dev-db/freecdb dev-db/cdb )"
RDEPEND=""

S=${WORKDIR}

skkdic2cdb () {

	awk '/^[^;]/ {
		printf "+%d,%d:%s->%s\n", length($1), length($2), $1, $2
	} END {
		print ""
	} ' $1
}

src_unpack () {

	unpack ${A}

	for i in *.${PV} ; do
		mv ${i} ${i/%.${PV}/}
	done
}

src_compile () {

	for i in SKK-JISYO* ; do
		echo "Converting $i into $i.cdb ..."
		skkdic2cdb $i | cdbmake $i.cdb tmp.$i
	done || die

	cd zipcode
	for j in SKK-JISYO* ; do
		skkdic2cdb $j | cdbmake $j.cdb tmp.$j
	done || die
}

src_install () {

	insinto /usr/share/skk
	for i in SKK-JISYO* zipcode/SKK-JISYO* ; do
		doins $i
	done || die

	dodoc edict_doc.txt
}
