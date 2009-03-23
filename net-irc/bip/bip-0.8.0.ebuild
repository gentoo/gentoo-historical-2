# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/bip/bip-0.8.0.ebuild,v 1.1 2009/03/23 15:58:15 a3li Exp $

EAPI="2"

DESCRIPTION="Multiuser IRC proxy with ssl support"
HOMEPAGE="http://bip.t1r.net/"
SRC_URI="http://bip.t1r.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ssl vim-syntax oidentd"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
	vim-syntax? ( || ( app-editors/vim
	app-editors/gvim ) )
	oidentd? ( >=net-misc/oidentd-2.0 )"

src_configure() {
	# configure broken: --disable-oidentd enables it, too
	local my_conf
	use oidentd && my_conf="--enable-oidentd"

	econf \
		$(use_enable ssl openssl)\
		$(use_enable debug)\
		${my_conf}
}

src_compile() {
	# Parallel make fails.
	# {C,CXX,LD}FLAGS aren't respected, bug 241030.
	emake CFLAGS="${CFLAGS}" CPPFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" -j1 || die "emake failed"
}

src_install() {
	dobin src/bip src/bipmkpw || die "dobin failed"

	dodoc AUTHORS ChangeLog README NEWS TODO || die "dodoc failed"
	newdoc samples/bip.conf bip.conf.sample || die "newdoc failed"
	doman bip.1 bip.conf.5 bipmkpw.1 || die "doman failed"

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins samples/bip.vim || die "doins failed"
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/bip.vim || die "doins failed"
	fi
}

pkg_postinst() {
	elog 'Default configuration file is "~/.bip/bip.conf"'
	elog "You can find a sample configuration file in"
	elog "/usr/share/doc/${PF}/bip.conf.sample"
}
