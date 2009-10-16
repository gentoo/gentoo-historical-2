# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/confix-wrapper/confix-wrapper-0.ebuild,v 1.3 2009/10/16 08:16:21 haubi Exp $

DESCRIPTION="Wrapper to select either confix1.py or confix2.py"
HOMEPAGE="http://confix.sourceforge.net"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-interix ~x86-linux ~x86-solaris"
IUSE=""

src_install() {
	dodir /usr/bin
	cat >> "${ED:-${D}}"usr/bin/confix <<EOF
#! ${EPREFIX:-}/bin/sh
confixpy=
if [ -f ./Confix2.dir ]; then
	confixpy=confix2.py
elif [ -f ./Makefile.py ]; then
	confixpy=confix1.py
else
	confixpy=confix2.py
fi
case \$# in
0) exec \${confixpy} ;;
*) exec \${confixpy} "\$@" ;;
esac
EOF
	fperms a+x /usr/bin/confix || die "cannot set permissions"
	dosym confix /usr/bin/confix.py || die "cannot create 'confix' symlink"
}
