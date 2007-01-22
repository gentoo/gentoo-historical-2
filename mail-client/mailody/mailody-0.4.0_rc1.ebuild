# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mailody/mailody-0.4.0_rc1.ebuild,v 1.1 2007/01/22 18:30:10 flameeyes Exp $

inherit kde

MY_P="${P/_/-}"

DESCRIPTION="IMAP mail client for KDE"
HOMEPAGE="http://www.mailody.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="=dev-db/sqlite-3*
	app-crypt/qca-tls"

S="${WORKDIR}/${MY_P}"

need-kde 3.5
