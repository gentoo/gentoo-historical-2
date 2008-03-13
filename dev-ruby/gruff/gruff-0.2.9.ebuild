# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/gruff/gruff-0.2.9.ebuild,v 1.3 2008/03/13 20:20:01 cla Exp $

inherit ruby gems

DESCRIPTION="A ruby library for creating pretty graphs and charts"
HOMEPAGE="http://rubyforge.org/projects/gruff/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/ruby-1.8.2
	>=dev-ruby/hoe-1.3.0
	dev-ruby/rmagick"

pkg_setup() {
	if ! built_with_use media-gfx/imagemagick truetype ; then
		eerror "media-gfx/imagemagick must be built with the truetype USE flag"
		eerror "in order for gruff to create graphics with text."
		eerror "Please re-emerge imagemagick with the truetype USE flag enabled."
		die "imagemagick does not have the truetype USE flag enabled"
	fi
}
