# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/yard/yard-2.0-r1.ebuild,v 1.2 2001/04/09 03:19:49 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Yard is a suite of Perl scripts for creating rescue disks (also
called bootdisks) for Linux."
SRC_URI="http://www.croftj.net/~fawcett/yard/${A}"
HOMEPAGE="http://www.croftj.net/~fawcett/yard/"

src_unpack() {
    unpack ${A}
    cd ${S}
    cp ${FILESDIR}/configure .
    cp Makefile.in Makefile.in.orig
    patch -p0 < ${FILESDIR}/${P}-Makefile.in-gentoo.diff
    patch -p0 < ${FILESDIR}/${P}-doc-Makefile.in-gentoo.diff
    patch -p0 < ${FILESDIR}/${P}-extras-Makefile.in-gentoo.diff
}

src_compile() {

    cd ${S}
    try ./configure --prefix=/usr
    try make

}

src_install () {

    cd ${S}
    try make DESTDIR=${D} install customize
    rm -rf ${D}/usr/share/doc/${P}
    cd doc
    docinto txt
    dodoc *.txt Broken*
    docinto html
    dodoc *.html
    docinto sgml
    dodoc *.sgml
    docinto print
    gunzip Yard_doc.ps.gz
    dodoc *.ps

    # Now overwrite to make it usable under gentoo

    # configure stuff

    cd ${FILESDIR}/${P}
    insinto /etc/yard
    doins etc/Bootdisk* etc/Config.pl
    insinto /etc/yard/Replacements/etc
    doins etc/Replacements/etc/[a-z]*
    chmod +x ${D}/etc/yard/Replacements/etc/rc
    insinto /etc/yard/Replacements/etc/pam.d
    doins etc/Replacements/pam.d/other
    insinto /etc/yard/Replacements/root
    doins etc/Replacements/root/profile

    # modified scripts

    exeinto /usr/sbin
    doexe sbin/{*_root_fs,mklibs.sh,write_rescue_disk,reduce_libs_root_fs}

    # devices

    dodir /etc/yard/Replacements/dev
    cd ${D}/etc/yard/Replacements/dev
    for i in hda hdb hdc hdd hde hdf hdg hdh scd
    do
      MAKEDEV $i
    done



}

