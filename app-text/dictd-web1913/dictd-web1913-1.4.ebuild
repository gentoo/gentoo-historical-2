# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Michael Conrad Tilstra <michael@gentoo.org> <tadpol@tadpol.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/dictd-web1913/dictd-web1913-1.4.ebuild,v 1.1 2001/04/24 22:07:29 michael Exp $

#P=
A=dict-web1913-1.4-pre.tar.gz
S=${WORKDIR}
DESCRIPTION=""
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${A}"
HOMEPAGE="http://www.dict.org"

DEPEND=">=app-text/dictd-1.5.5"

src_install () {
	dodir /usr/lib/dict
	insinto /usr/lib/dict
	doins web1913.dict.dz
	doins web1913.index
}

pkg_postinst() {
if [ -f /etc/dict/dictd.conf ]; then
cat >> /etc/dict/dictd.conf << __EOF__
database web1913  { data "/usr/lib/dict/web1913.dict.dz"
                    index "/usr/lib/dict/web1913.index" }
__EOF__
fi
}


# vim: ai et sw=4 ts=4
