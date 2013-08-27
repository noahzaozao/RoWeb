package inoah.game.td
{
    public class ConstsParticle
    {
        [Embed(source="../../../../circle.png")]
        public static const CIRCLE:Class;
        
        public static const FIRE_BALL:XML = XML(
            <particleEmitterConfig>
              <maxParticles value="100"/>
              <particleLifeSpan value="1"/>
              <particleLifespanVariance value="1"/>
              <startParticleSize value="20"/>
              <startParticleSizeVariance value="1"/>
              <finishParticleSize value="10"/>
              <FinishParticleSizeVariance value="1"/>
              <angle value="270"/>
              <angleVariance value="2"/>
              <rotationStart value="0"/>
              <rotationStartVariance value="0"/>
              <rotationEnd value="0"/>
              <rotationEndVariance value="0"/>
              <startColor alpha="0.6" red="1" green="0.25" blue="0"/>
              <startColorVariance alpha="0" red="0" green="0" blue="0"/>
              <finishColor alpha="0" red="1" green="0.25" blue="0"/>
              <finishColorVariance alpha="0" red="0" green="0" blue="0"/>
              <blendFuncSource value="770"/>
              <blendFuncDestination value="1"/>
              <emitterType value="1"/>
              <sourcePositionVariance x="0" y="0"/>
              <speed value="100"/>
              <speedVariance value="30"/>
              <gravity x="0" y="0"/>
              <radialAcceleration value="0"/>
              <radialAccelVariance value="0"/>
              <tangentialAcceleration value="0"/>
              <tangentialAccelVariance value="0"/>
              <maxRadius value="20"/>
              <maxRadiusVariance value="0"/>
              <minRadius value="0"/>
              <rotatePerSecond value="0"/>
              <rotatePerSecondVariance value="0"/>
            </particleEmitterConfig>);
    }
}