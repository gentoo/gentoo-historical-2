# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase/kdebase-2.2.2.ebuild,v 1.4 2001/12/09 19:09:58 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-dist || die

DESCRIPTION="${DESCRIPTION}Base"

NEWDEPEND=">=media-sound/cdparanoia-3.9.8
	ldap? ( >=net-nds/openldap-1.2 ) 
	pam? ( >=sys-libs/pam-0.73 ) 
	motif? ( >=x11-libs/openmotif-2.1.30 ) 
	lame? ( >=media-sound/lame-3.89b ) 
	vorbis? ( >=media-libs/libvorbis-1.0_beta1 )
	cups? ( net-print/cups )
	ssl? ( >=dev-libs/openssl-0.9.6b )
	media-sound/cdparanoia
	opengl? ( virtual/opengl )" #this last for opengl screensavers
#	fam? ( app-admin/fam-oss ) #someone who uses this needs to enable the rc script for fam, we need to find a way of telling users to do so
#	samba? ( net-fs/samba ) #use flag doesn't exist yet and we don't want such a heavy dep by deafult
#	lm_sensors? ( ?/lm_sensors ) # ebuild doesn't exist yet

DEPEND="$DEPEND $NEWDEPEND"
RDEPEND="$RDEPEND $NEWDEPEND"

src_compile() {
    
    kde_src_compile myconf
    
    use ldap	&& myconf="$myconf --with-ldap" || myconf="$myconf --without-ldap"
    use pam	&& myconf="$myconf --with-pam"	|| myconf="$myconf --with-shadow"
    use motif					|| myconf="$myconf --without-motif"
    use lame					|| myconf="$myconf --without-lame"
    use cups					|| myconf="$myconf --disable-cups"
    use vorbis					|| myconf="$myconf --without-vorbis"
    use opengl					|| myconf="$myconf --without-gl"
    use ssl					|| myconf="$myconf --without-ssl"
    
    kde_src_compile configure make

}


src_install() {

    kde_src_install

    insinto /etc/pam.d
    newins ${FILESDIR}/kscreensaver.pam kscreensaver
    newins kde.pamd kde
    
    cd ${D}/${KDEDIR}/bin
    sed -e "s:^#\!/bin/sh:#\!/bin/sh --login:" \
	-e "s/LD_BIND_NOW=true//" \
	startkde | cat > startkde.tmp
    mv startkde.tmp startkde
    chmod a+x startkde

    exeinto /usr/X11R6/bin/wm
    doexe ${FILESDIR}/{kde${PV},xsession}
    cd ${D}/usr/X11R6/bin/wm
    ln -sf kde${PV} kde

    cd ${D}/${KDEDIR}/share/config/kdm
    mv kdmrc kdmrc.orig
    sed -e 's/SessionTypes=/SessionTypes=xsession,/' kdmrc.orig | cat > kdmrc
    rm kdmrc.orig
    
    dodir ${KDEDIR}/share/templates/.source/emptydir
  
}
