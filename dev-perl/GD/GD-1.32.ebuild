# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GD/GD-1.32.ebuild,v 1.4 2002/07/11 06:30:21 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl DBI Module"
SRC_URI="http://www.cpan.org/modules/by-module/GD/${A}"
HOMEPAGE="http://www.cpan.org/modules/by-module/GD/${P}.readme"

DEPEND=">=sys-devel/perl-5
	>=media-libs/libgd-1.8.3"

src_unpack() {
  unpack ${A}
  cd ${S}
  cp Makefile.PL Makefile.PL.orig
  sed -e "s:my \$JPEG.*:my \$JPEG='y';:" \
      -e "s:my \$TTF.*:my \$TTF='y';:" \
      Makefile.PL.orig > Makefile.PL
  if [ "`use X`" ]
  then
    cp Makefile.PL Makefile.PL.orig
    sed -e "s:my \$XPM.*:my \$XPM='y';:" \
      Makefile.PL.orig > Makefile.PL
  fi

}
src_compile() {
    perl Makefile.PL
    try make
    try make test
}

src_install () {
    try make PREFIX=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 install
    dodoc ChangeLog MANIFEST README*
    docinto html
    dodoc GD.html
}



