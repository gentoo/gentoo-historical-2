# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gd/ruby-gd-0.8.0.ebuild,v 1.1 2010/01/16 18:06:21 graaff Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="Changes readme.en readme.ja"

inherit ruby-fakegem

DESCRIPTION="ruby-gd: an interface to Boutell GD library"
HOMEPAGE="http://rubyforge.org/projects/ruby-gd/"

RUBY_PATCHES=( "${FILESDIR}/ruby-gd-0.7.4-fix-interlace.patch" )

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="jpeg truetype X"

DEPEND="
	>=media-libs/gd-2.0[png]
	jpeg? ( media-libs/jpeg )
	truetype? ( media-libs/freetype )
	X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

each_ruby_configure() {
	local myconf=""

	if use truetype; then
		myconf="${myconf} --with-ttf --with-freetype"
	fi

	${RUBY} extconf.rb --enable-gd2_0 ${myconf} \
		$(use_with jpeg) \
		$(use_with X xpm) || die
}

each_ruby_compile() {
	emake
}

each_ruby_install() {
	ruby_fakegem_genspec
	emake DESTDIR="${D}" install || die
}

all_ruby_install() {
	dodoc Changes readme.* doc/manual.rd doc/INSTALL.* || die
	dohtml doc/manual.html doc/manual_index.html
	insinto /usr/share/doc/${PF}/sample
	doins sample/*
}
