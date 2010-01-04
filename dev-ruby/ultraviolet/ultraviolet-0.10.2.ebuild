# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ultraviolet/ultraviolet-0.10.2.ebuild,v 1.3 2010/01/04 12:02:18 fauli Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="A syntax highlighting engine based on Textpow"
HOMEPAGE="http://ultraviolet.rubyforge.org/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND=">=dev-ruby/textpow-0.10.0"
RDEPEND="${DEPEND}"
