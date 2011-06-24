# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/perl-support/perl-support-4.12.ebuild,v 1.1 2011/06/24 17:50:32 radhermit Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: Perl-IDE - Write and run Perl scripts using menus and hotkeys"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=556"
SRC_URI="https://github.com/vim-scripts/${PN}.vim/tarball/${PV} -> ${P}.tar.gz"
LICENSE="as-is"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

VIM_PLUGIN_HELPFILES="perlsupport"

RDEPEND="dev-perl/Perl-Tags
	dev-perl/Perl-Critic"

src_unpack() {
	unpack ${A}
	mv *-${PN}.vim-* "${S}"
}

src_prepare() {
	# Don't set tabstop and shiftwidth
	sed -i -e '/=4/s/^/"/' ftplugin/perl.vim
}

src_install() {
	dodoc doc/{ChangeLog,perl-hot-keys.pdf}
	rm doc/{ChangeLog,perl-hot-keys.*,pmdesc3.text}
	vim-plugin_src_install
}
