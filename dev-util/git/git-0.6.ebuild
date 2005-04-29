# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/git/git-0.6.ebuild,v 1.3 2005/04/29 13:36:22 r3pek Exp $

DESCRIPTION="GIT - the stupid content tracker"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/torvalds/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/people/torvalds/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/openssl
		sys-libs/zlib
		!dev-util/git-pasky
		!dev-util/cogito"

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	dobin cat-file checkout-cache commit-tree diff-tree fsck-cache init-db \
			read-tree show-diff update-cache write-tree check-files \
			convert-cache diff-cache git-export git-merge-one-file-script \
			git-prune-script git-pull-script ls-tree merge-base merge-cache \
			rev-tree show-files unpack-file || die "dobin failed"
	dodoc README || die "dodoc failed"
}
