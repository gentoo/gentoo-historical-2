# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/bip/bip-0.6.1.ebuild,v 1.1 2007/11/20 09:15:58 hawking Exp $

DESCRIPTION="Multiuser IRC proxy with ssl support"
HOMEPAGE="http://bip.t1r.net/"
SRC_URI="http://bip.t1r.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl vim-syntax"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
	vim-syntax? ( || ( app-editors/vim
	app-editors/gvim ) )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix bip.vim
	if use vim-syntax; then
		sed -i \
			-e 's/^\(no_client_away_msg\)/\t\\ \1/' \
			-e 's/always_backlog/backlog_always/' \
			-e 's/bl_msg_only/backlog_msg_only/' \
			samples/bip.vim || die "sed failed"
	fi
}

src_compile() {
	econf $(use_enable ssl)
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin src/bip src/bipmkpw

	dodoc AUTHORS ChangeLog README README.floodcontrol NEWS TODO
	newdoc samples/bip.conf bip.conf.sample
	doman bip.1 bip.conf.1 bipmkpw.1

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins samples/bip.vim
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/bip.vim
	fi
}

pkg_postinst() {
	elog 'Default configuration file is "~/.bip/bip.conf"'
	elog "You can find a sample configuration file in"
	elog "/usr/share/doc/bip-0.6.1/bip.conf.sample.bz2"
}
