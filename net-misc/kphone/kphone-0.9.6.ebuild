# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

S="${WORKDIR}/${P}"
need-kde 2
DESCRIPTION="a SIP user agent for Linux, with which you can initiate VoIP connections over the Internet."
SRC_URI="http://www.wirlab.net/kphone/kphone-0.9.6.tgz"
HOMEPAGE="http://www.wirlab.net/kphone/index.html"
