# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amstd/amstd-1.9.5.ebuild,v 1.2 2001/01/16 17:13:14 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Standard libraries for Ruby"
SRC_URI="http://www1.u-netsurf.ne.jp/~brew/mine/soft/${A}"
HOMEPAGE="http://www1.u-netsurf.ne.jp/~brew/mine/en/index.html"

DEPEND=">=dev-lang/ruby-1.6.1"

src_compile() {
    cd ${S}
    try ruby setup.rb config
    try ruby setup.rb setup
}

src_install () {
    cd ${S}
    try ruby setup.rb install --bin-dir=${D}/usr/bin \
        --rb-dir=${D}/usr/lib/ruby/site_ruby/1.6 \
        --so-dir=${D}/usr/lib/ruby/site_ruby/1.6/${CHOST%%-*}-linux-gnu
}
