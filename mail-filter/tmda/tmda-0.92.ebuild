# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/tmda/tmda-0.92.ebuild,v 1.2 2004/06/24 22:23:06 agriffis Exp $

DESCRIPTION="Python-based SPAM reduction system"
HOMEPAGE="http://www.tmda.net/"
LICENSE="GPL-2"

DEPEND=">=dev-lang/python-2.2
	virtual/mta"

SRC_URI="http://tmda.sf.net/releases/${P}.tgz
	http://tmda.sf.net/releases/old/${P}.tgz"

SLOT="0"
KEYWORDS="x86 ~sparc"

S="${WORKDIR}/${P}"

src_compile () {
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
	insinto "/usr/lib/python${pv}/site-packages/TMDA/pythonlib/email"
	doins TMDA/pythonlib/email/*.py*

	# The templates
	insinto /etc/tmda
	doins templates/*.txt

	# Documentation
	dodoc COPYING ChangeLog README THANKS UPGRADE CRYPTO CODENAMES INSTALL
	dohtml -r htdocs/*.html
	dohtml -r htdocs/img

	# Contributed binaries and stuff
	cd ${S}/contrib

	exeinto /usr/lib/tmda/contrib
	doexe collectaddys def2html getuserinfo-vpopmail.sh printcdb printdbm \
	      sendit.sh smtp-check-sender update-internaldomains vadduser-tmda \
	      vmailmgr-vdir.sh vpopmail-vdir.sh wrapfd3.sh

	insinto /usr/lib/tmda/contrib
	doins ChangeLog sample.config tmda.el tmda.spec \
	      tofmipd.init tofmipd.sysconfig vtmdarc

}
