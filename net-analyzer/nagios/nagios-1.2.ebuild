# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios/nagios-1.2.ebuild,v 1.2 2004/06/24 22:08:02 agriffis Exp $

DESCRIPTION="The Nagios metapackage - merge this to pull install all of the nagios packages"
HOMEPAGE="http://www.nagios.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"

RDEPEND=">=net-analyzer/nagios-core-1.2
	>=net-analyzer/nagios-plugins-1.3.1
	>=net-analyzer/nagios-nrpe-1.8
	>=net-analyzer/nagios-nsca-2.3
	>=net-analyzer/nagios-imagepack-1.0"

