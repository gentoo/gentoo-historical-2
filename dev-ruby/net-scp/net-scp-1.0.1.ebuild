# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/net-scp/net-scp-1.0.1.ebuild,v 1.2 2008/09/21 13:50:14 ranger Exp $

inherit gems

DESCRIPTION="A pure Ruby implementation of the SCP client protocol"
HOMEPAGE="http://net-ssh.rubyforge.org/scp"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-ruby/net-ssh-2.0.0"
