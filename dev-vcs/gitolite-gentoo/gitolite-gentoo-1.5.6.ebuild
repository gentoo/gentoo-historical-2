# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/gitolite-gentoo/gitolite-gentoo-1.5.6.ebuild,v 1.1 2010/11/02 21:08:07 idl0r Exp $

EAPI=3

inherit eutils perl-module

DESCRIPTION="Highly flexible server for git directory version tracker"
HOMEPAGE="http://github.com/sitaramc/gitolite"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="contrib vim-syntax"

DEPEND="dev-lang/perl
	>=dev-vcs/git-1.6.2"
RDEPEND="${DEPEND}
	!dev-vcs/gitolite
	vim-syntax? ( app-vim/gitolite-syntax )"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitolite git
}

src_prepare() {
	epatch "${FILESDIR}/gitolite-require.patch"

	rm -rf Makefile doc/COPYING contrib/{autotoc,gitweb,vim}

	echo "${PF}" > conf/VERSION
}

src_install() {
	dodir /usr/share/gitolite/{conf,hooks} /usr/bin || die

	./src/gl-system-install "${D}"/usr/bin \
		"${D}"/usr/share/gitolite/conf "${D}"/usr/share/gitolite/hooks || die
	dosed "s:${D}::g" usr/bin/gl-setup \
		usr/share/gitolite/conf/example.gitolite.rc || die

	rm "${D}/usr/bin/gitolite.pm"
	insinto "${VENDOR_LIB}"
	doins src/gitolite.pm || die

	dodoc README.mkd doc/*

	if use contrib; then
		insinto /usr/share/doc/${PF}
		doins -r contrib/ || die
	fi

	keepdir /var/lib/gitolite
	fowners git:git /var/lib/gitolite
	fperms 750 /var/lib/gitolite
}
