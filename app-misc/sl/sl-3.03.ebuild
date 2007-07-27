# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/sl/sl-3.03.ebuild,v 1.17 2007/07/27 22:34:37 grobian Exp $

inherit eutils toolchain-funcs flag-o-matic

SL_PATCH="sl5-1.patch"

DESCRIPTION="sophisticated graphical program which corrects your miss typing"
HOMEPAGE="http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/ http://www.linet.gr.jp/~izumi/sl/"
SRC_URI="http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/sl/${PN}.tar
	http://www.linet.gr.jp/~izumi/sl/${SL_PATCH}
	http://www.sodan.ecc.u-tokyo.ac.jp/~okayama/sl/${PN}.en.1.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86 alpha sparc ppc64 ppc ~amd64 hppa"
IUSE="linguas_ja debug"

DEPEND="sys-libs/ncurses"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${PN}.tar
	cd "${S}"
	epatch "${DISTDIR}/${SL_PATCH}"
	epatch "${FILESDIR}/${P}-gentoo.diff"
	unpack ${PN}.en.1.gz
}

doecho() {
	echo "$@"
	"$@"
}

src_compile() {
	use debug && append-flags -DDEBUG

	doecho "$(tc-getCC)" ${CFLAGS} ${LDFLAGS} sl.c -lncurses -o sl

	if use linguas_ja; then
		iconv -f ISO-2022-JP -t EUC-JP sl.1 > sl.ja.1
	fi
}

src_install() {
	dobin sl || die
	newman sl.en.1 sl.1
	dodoc README* sl.txt
	if use linguas_ja ; then
		insinto /usr/share/man/ja/man1
		newins sl.ja.1 sl.1
	fi
}
