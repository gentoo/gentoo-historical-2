# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Arcady Genkin <agenkin@thpoon.com>
# $Header: /var/cvsroot/gentoo-x86/net-mail/tmda/tmda-0.48.ebuild,v 1.1 2002/03/02 03:33:30 agenkin Exp $

S="${WORKDIR}/${P}"

DESCRIPTION="Python-based SPAM reduction system"
SRC_URI="http://software.libertine.org/tmda/releases/${P}.tgz"
HOMEPAGE="http://software.libertine.org/tmda/index.html"

DEPEND=">=dev-lang/python-2.0
        virtual/mta"

src_compile() {
        ./compileall || die
}

src_install () {
        # Figure out python version
        # below hack should be replaced w/ pkg-config, when we get it working
        local pv=`python -V 2>&1 | sed -e 's:Python \([0-9].[0-9]\).*:\1:'`

        # Executables
        dobin bin/tmda-*

        # The Python TMDA module
        insinto "/usr/lib/python${pv}/site-packages/TMDA"
        doins TMDA/*.py*

        # The templates
        insinto /etc/tmda
        doins templates/*.txt
        
        # Documentation
        dodoc COPYRIGHT ChangeLog README THANKS UPGRADE CRYPTO
        dohtml -r htdocs/*.html

        # Contributed binaries and stuff
        cd contrib
        dodoc README.RELAY qmail-smtpd_auth.patch tmda.spec sample.tmdarc
        exeinto /usr/lib/tmda/bin
        doexe printcdb printdbm
        insinto /usr/lib/tmda
        doins setup.pyc
        exeinto /usr/lib/tmda
        doexe setup.py
}
