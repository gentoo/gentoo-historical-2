# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rmagick/rmagick-1.3.2.ebuild,v 1.7 2005/03/16 15:59:02 caleb Exp $

MY_P="RMagick-${PV}"
DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="http://rmagick.rubyforge.org/"
SRC_URI="http://rubyforge.org/download.php/243/${MY_P}.tar.bz2"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha hppa ~mips ppc sparc x86"
IUSE=""
DEPEND="virtual/ruby
	>=media-gfx/imagemagick-5.5.1"
S=${WORKDIR}/${MY_P}

src_compile() {
	./configure || die
	ruby install.rb config --prefix=/usr --doc-dir=/usr/share/doc/${PF}/html || die
	ruby install.rb setup || die
}

src_install() {
	ruby install.rb config --prefix=${D}/usr --doc-dir=${D}/usr/share/doc/${PF}/html || die
	ruby install.rb install || die
	dodoc ChangeLog README.*
}
