# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/metasploit/metasploit-2.3.ebuild,v 1.1 2005/02/13 13:59:49 dragonheart Exp $

DESCRIPTION="The Metasploit Framework is an advanced open-source platform for developing, testing, and using vulnerability exploit code."
HOMEPAGE="http://www.metasploit.org/"

# Need to change the name
MY_P=${P/metasploit/framework}

SRC_URI="http://metasploit.com/tools/${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P}

LICENSE="GPL-2 Artistic"

SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="dev-lang/perl
	 dev-perl/Net-SSLeay
	 dev-perl/Term-ReadLine-Perl"

src_compile() {
	einfo "Nothing to build, jumping to install..."
}

src_install() {
	dodir /usr/lib/
	dodir /usr/bin/

	# should be as simple as copying everything into the target...
	cp -a ${S} ${D}usr/lib/metasploit || die

	# and creating symlinks in the /usr/bin dir
	cd ${D}/usr/bin
	ln -s ../lib/metasploit/msf* ./ || die
	chown -R root:root ${D}
}

pkg_postinst() {
	ewarn "You may wish to perform a metasploit update to get"
	ewarn "the latest modules (e.g. run 'msfupdate -u')"
}
